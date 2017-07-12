//
//  DYYPlayerDownloader.m
//  DYYPlayer
//
//  Created by yang on 2017/7/11.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYPlayerDownloader.h"
#import "DYYPlayerFile.h"
@interface DYYPlayerDownloader()<NSURLSessionDataDelegate>
@property (nonatomic, strong)NSURLSession *session;
@property (nonatomic, strong)NSOutputStream *stream;
@property (nonatomic, strong)NSURL *url;

@end
@implementation DYYPlayerDownloader
-(NSURLSession *)session{

    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
- (void)downloader:(NSURL *)url offset:(long long)offset{
    self.url = url;
    self.offset = offset;
    [self cancleAndClean];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
    
}
- (void)cancleAndClean{

    [self.session invalidateAndCancel];
    self.session = nil;
    [DYYPlayerFile clearTempFile:self.url];
    self.loadedSize = 0;
}
#pragma mark - delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    self.totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    self.mineType = response.MIMEType;
    
    self.stream = [NSOutputStream outputStreamToFileAtPath:[DYYPlayerFile tempFilePath:self.url] append:YES];
    [self.stream open];
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    self.loadedSize += data.length;
    [self.stream write:data.bytes maxLength:data.length];
    if ([self.delegate respondsToSelector:@selector(downloading)]) {
        [self.delegate downloading];
    }

}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (!error) {
        
        if ([DYYPlayerFile tempFileSize:self.url] == _totalSize) {
            [DYYPlayerFile moveTempPathToCachePath:self.url];
        }else if([DYYPlayerFile tempFileSize:self.url] > _totalSize){
            [DYYPlayerFile clearTempFile:self.url];
        }
    }else {
    
        NSLog(@"请求错误");
    }
   [self.stream close];
}
@end
