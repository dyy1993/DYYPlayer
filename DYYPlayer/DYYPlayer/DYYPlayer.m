//
//  DYYPlayer.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface DYYPlayer()
@property (nonatomic, strong)AVPlayer *player;
@end
@implementation DYYPlayer
static DYYPlayer *_sharePlayer;
+ (instancetype)sharePlayer{
    if (!_sharePlayer) {
        _sharePlayer = [[self alloc] init];
    }
    return _sharePlayer;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharePlayer = [super allocWithZone:zone];
    });
    return _sharePlayer;
}

- (void)playWithUrl:(NSURL *)url{
    [self removeObserver];

    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)pause{
    
    [self.player pause];
}
- (void)resume{

    [self.player play];
}
- (void)stop{

    [self.player pause];
    [self removeObserver];
    self.player = nil;

}
- (void)seekWithProgress:(float)progress{
    if (progress < 0 || progress > 1) {
        return;
    }

    CMTime duration = self.player.currentItem.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    float seekSeconds = durationSeconds * progress;
    CMTime seekTime = CMTimeMake(seekSeconds, 1);
    
    [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"加载成功");
        }else{
            NSLog(@"取消加载");
        }
    }];
    
}
- (void)seekWithTimeDiffer:(float)timeDiffer{

    float seekTime = CMTimeGetSeconds(self.player.currentTime) + timeDiffer;
    float durationTime = CMTimeGetSeconds(self.player.currentItem.duration);
    float progress = seekTime / durationTime;
    [self seekWithProgress:progress];
 
}
- (void)setRate:(float)rate{
    [self.player setRate:rate];
}
- (void)setMute:(BOOL)mute{

    [self.player setMuted:mute];
}
- (void)setVolume:(float)volume{

    if (volume < 0 || volume > 1) {
        return;
    }
    [self.player setVolume:volume];
}
#pragma mark - KVO
- (void)removeObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"status"]) {
        if ([change[NSKeyValueChangeNewKey] integerValue] == AVPlayerItemStatusReadyToPlay) {
            //加载完毕
            NSLog(@"加载完毕");
            [self.player play];
        }else {
            //取消加载
            NSLog(@"取消加载");
        }
    }
}
@end
