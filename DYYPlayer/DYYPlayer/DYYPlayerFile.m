//
//  DYYPlayerFile.m
//  DYYPlayer
//
//  Created by yang on 2017/7/11.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYPlayerFile.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTempPath NSTemporaryDirectory()
@implementation DYYPlayerFile

+ (NSString *)cacheFilePath:(NSURL *)url{

    return [kCachePath stringByAppendingPathComponent:url.lastPathComponent];

}

+ (BOOL)cacheFileExists:(NSURL *)url{
    
    NSString *filePath = [self cacheFilePath:url];
   return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (long long)cacheFileSize:(NSURL *)url{
    NSString *filePath = [self cacheFilePath:url];
    if (![self cacheFileExists:url]) {
        return 0;
    }
    
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [attr[NSFileSize] longLongValue];
}



+ (NSString *)tempFilePath:(NSURL *)url{
    
    return [kTempPath stringByAppendingPathComponent:url.lastPathComponent];
}
+ (BOOL)tempFileExists:(NSURL *)url{
    
    NSString *filePath = [self tempFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}
+ (long long)tempFileSize:(NSURL *)url{
    NSString *filePath = [self tempFilePath:url];
    if (![self tempFileExists:url]) {
        return 0;
    }
    
    NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [attr[NSFileSize] longLongValue];
}
+ (void)clearTempFile:(NSURL *)url {
    NSString *tmpPath = [self tempFilePath:url];
    BOOL isDirectory = YES;
    BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDirectory];
    if (isEx && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
    
}

+ (NSString *)contentType:(NSURL *)url{
    NSString *path = [self cacheFilePath:url];
    NSString *fileExtension = path.pathExtension;
    
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    
    return contentType;
}

+ (void)moveTempPathToCachePath:(NSURL *)url{

    NSString *tempPath = [self tempFilePath:url];
    NSString *cachePath = [self cacheFilePath:url];
    [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:cachePath error:nil];

}


@end
