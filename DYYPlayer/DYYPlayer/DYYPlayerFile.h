//
//  DYYPlayerFile.h
//  DYYPlayer
//
//  Created by yang on 2017/7/11.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYPlayerFile : NSObject
+ (NSString *)cacheFilePath:(NSURL *)url;
+ (BOOL)cacheFileExists:(NSURL *)url;
+ (long long)cacheFileSize:(NSURL *)url;


+ (NSString *)tempFilePath:(NSURL *)url;
+ (BOOL)tempFileExists:(NSURL *)url;
+ (long long)tempFileSize:(NSURL *)url;
+ (void)clearTempFile:(NSURL *)url;

+ (NSString *)contentType:(NSURL *)url;
+ (void)moveTempPathToCachePath:(NSURL *)url;

@end
