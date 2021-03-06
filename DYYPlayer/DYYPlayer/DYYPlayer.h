//
//  DYYPlayer.h
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, DYYPlayerState) {
    DYYPlayerStateUnknow,
    DYYPlayerStatePlaying,
    DYYPlayerStatePause,
    DYYPlayerStateLoading,
    DYYPlayerStateStopped,
    DYYPlayerStateFailed
};
@interface DYYPlayer : NSObject
+ (instancetype)sharePlayer;

- (void)playWithUrl:(NSURL *)url isCache:(BOOL)isCache;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)seekWithProgress:(float)progress;
- (void)seekWithTimeDiffer:(float)timeDiffer;


@property (nonatomic, assign)float volume;
@property (nonatomic, assign)BOOL muted;
@property (nonatomic, assign)float rate;

@property (nonatomic, assign, readonly)NSTimeInterval totalTime;
@property (nonatomic, copy, readonly)NSString *totalTimeFormat;
@property (nonatomic, assign, readonly)NSTimeInterval currentTime;
@property (nonatomic, copy, readonly)NSString *currentTimeFormat;

@property (nonatomic, strong, readonly)NSURL *currentRrl;
@property (nonatomic, assign, readonly)float progress;
@property (nonatomic, assign, readonly)float loadDataProgress;

@property (nonatomic, assign, readonly)DYYPlayerState state;

@property (nonatomic, strong)AVPlayer *player;

@end
