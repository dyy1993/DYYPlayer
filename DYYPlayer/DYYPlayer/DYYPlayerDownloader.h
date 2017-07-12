//
//  DYYPlayerDownloader.h
//  DYYPlayer
//
//  Created by yang on 2017/7/11.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DYYPlayerDownloaderDelegate <NSObject>
- (void) downloading;
@end

@interface DYYPlayerDownloader : NSObject

@property(nonatomic, weak)id<DYYPlayerDownloaderDelegate> delegate;

@property(nonatomic, assign)long long loadedSize;
@property(nonatomic, assign)long long offset;
@property(nonatomic, assign)long long totalSize;
@property(nonatomic, copy)NSString *mineType;

- (void)downloader:(NSURL *)url offset:(long long)offset;

@end
