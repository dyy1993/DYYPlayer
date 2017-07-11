//
//  DYYResourceLoaderDelegate.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYResourceLoaderDelegate.h"

@implementation DYYResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{

    NSLog(@"%@",loadingRequest);
    loadingRequest.contentInformationRequest.contentLength = 9385242;
    loadingRequest.contentInformationRequest.contentType = @"public.mp4";
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    NSData *data = [NSData dataWithContentsOfFile:@"/Users/yang/Desktop/minion_02.mp4" options:NSDataReadingMappedIfSafe error:nil];
    
   long long offset = loadingRequest.dataRequest.requestedOffset;
    NSInteger length = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(offset, length)];
    [loadingRequest.dataRequest respondWithData:subData];
    [loadingRequest finishLoading];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{

    NSLog(@"取消请求");
}
@end
