//
//  DYYPlayer.h
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYPlayer : NSObject
+ (instancetype)sharePlayer;

- (void)playWithUrl:(NSURL *)url;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)seekWithProgress:(float)progress;
- (void)seekWithTimeDiffer:(float)timeDiffer;
- (void)setRate:(float)rate;
- (void)setMute:(BOOL)mute;
- (void)setVolume:(float)volume;
@end
