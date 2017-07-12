//
//  DYYResourceLoaderDelegate.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYResourceLoaderDelegate.h"
#import "DYYPlayerFile.h"
#import "DYYPlayerDownloader.h"
#import "NSURL+Agreement.h"
@interface DYYResourceLoaderDelegate()<DYYPlayerDownloaderDelegate>
@property (nonatomic, strong)DYYPlayerDownloader *downloader;
@property (nonatomic, strong)NSMutableArray *loadingRequests;
@end
@implementation DYYResourceLoaderDelegate
-(DYYPlayerDownloader *)downloader{

    if (!_downloader) {
        _downloader = [[DYYPlayerDownloader alloc] init];
        _downloader.delegate = self;
    }
    return _downloader;
}
-(NSMutableArray *)loadingRequests{

    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{

    NSLog(@"%@",loadingRequest);
    NSLog(@"%@",@"请求数据");
    NSURL *url = [loadingRequest.request.URL httpUrl];
 //    缓存中有取缓存
    if ([DYYPlayerFile cacheFileExists:loadingRequest.request.URL]) {
        [self handlerCacheWihtRequested:loadingRequest];
        return YES;
    }
//    没有下载
    [self.loadingRequests addObject:loadingRequest];
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    long long currentOffset = loadingRequest.dataRequest.currentOffset;
    if (requestOffset != currentOffset) {
        requestOffset = currentOffset;
    }

    if (self.downloader.loadedSize == 0) {
        
        [self.downloader downloader:url offset:requestOffset];
        return YES;
    }
//    需要重新下载
    if (requestOffset < self.downloader.offset || requestOffset > self.downloader.offset + self.downloader.loadedSize + 1000) {
        [self.downloader downloader:url offset:requestOffset];
        return YES;
    }
//   处理请求数据
    [self handlerAllRequested];
   
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    [self.loadingRequests removeObject:loadingRequest];
    NSLog(@"取消请求");
}
- (void)handlerAllRequested{

    NSMutableArray *arrayM = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequests) {
//        
        NSURL *url = loadingRequest.request.URL;
//        long long contentLength = [DYYPlayerFile cacheFileSize:url];
//        NSString *contentType = [DYYPlayerFile contentType:url];
//        填充响应头
        
        loadingRequest.contentInformationRequest.contentLength = self.downloader.totalSize;
        loadingRequest.contentInformationRequest.contentType = self.downloader.mineType;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
//        返回数据
        NSString *filePath = [DYYPlayerFile tempFilePath:url];
        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
        if (data == nil) {
            data = [NSData dataWithContentsOfFile:[DYYPlayerFile cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
        }
        
        long long requestedOffset = loadingRequest.dataRequest.requestedOffset;
        long long currentOffset = loadingRequest.dataRequest.currentOffset;
        if (requestedOffset != currentOffset) {
            requestedOffset = currentOffset;
        }
        
        NSInteger requestedLength = loadingRequest.dataRequest.requestedLength;
        long long responseOffset = requestedOffset - self.downloader.offset;
        long long responseLength = MIN(self.downloader.offset + self.downloader.loadedSize - requestedOffset, requestedLength);
        
        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        [loadingRequest.dataRequest respondWithData:subData];
//       结束
        if (responseLength == requestedLength) {
            [loadingRequest finishLoading];
            [arrayM addObject:loadingRequest];
        }

    }
    
    [self.loadingRequests removeObjectsInArray:arrayM];
}
#pragma mark - dwonload delegate
-(void)downloading{

    [self handlerAllRequested];
}

#pragma mark - 取缓存
- (void)handlerCacheWihtRequested:(AVAssetResourceLoadingRequest *)loadingRequest{
    NSURL *url = loadingRequest.request.URL;
    long long contentLength = [DYYPlayerFile cacheFileSize:url];
    NSString *contentType = [DYYPlayerFile contentType:url];
    
    loadingRequest.contentInformationRequest.contentLength = contentLength;
    loadingRequest.contentInformationRequest.contentType = contentType;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    NSString *filePath = [DYYPlayerFile cacheFilePath:url];
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    
    long long offset = loadingRequest.dataRequest.requestedOffset;
    NSInteger length = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(offset, length)];
    [loadingRequest.dataRequest respondWithData:subData];
    [loadingRequest finishLoading];
}
@end
