//
//  DYYPlayer.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface DYYPlayer(){
    BOOL _isUserPause;
}
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
    
    if ([url isEqual:((AVURLAsset *)self.player.currentItem.asset).URL]) {
        [self resume];
        return;
    }
   
    _currentRrl = url;
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    if (self.player.currentItem) {
        [self removeObserver];
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
}


- (void)pause{
    
    [self.player pause];
    _isUserPause = YES;
    if (self.player) {
        self.state = DYYPlayerStatePause;
    }
}
- (void)resume{

    [self.player play];
    _isUserPause = NO;
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.state = DYYPlayerStatePlaying;
    }
}
- (void)stop{

    [self.player pause];
    [self removeObserver];
    self.player = nil;
    self.state = DYYPlayerStateStopped;

}
- (void)seekWithProgress:(float)progress{
    if (progress < 0 || progress > 1) {
        return;
    }
    float seekSeconds = self.totalTime * progress;
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
    if (self.totalTime == 0) {
        return;
    }
    float seekTime = self.currentTime + timeDiffer;
    float progress = seekTime / self.totalTime;
    [self seekWithProgress:progress];
 
}
- (void)setRate:(float)rate{
    [self.player setRate:rate];
}
- (void)setMuted:(BOOL)muted{

    [self.player setMuted:muted];
}
- (void)setVolume:(float)volume{

    if (volume < 0 || volume > 1) {
        return;
    }
    [self setMuted:NO];
    [self.player setVolume:volume];
}

- (void)setState:(DYYPlayerState)state{

    _state = state;
}
#pragma mark - 数据
- (NSTimeInterval)totalTime{
    
    NSTimeInterval durationSec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(durationSec)) {
        return 0;
    }
    return durationSec;
}
- (NSTimeInterval)currentTime{
    NSTimeInterval currentSec = CMTimeGetSeconds(self.player.currentTime);
    if (isnan(currentSec)) {
        return 0;
    }
    return currentSec;
}
- (NSString *)totalTimeFormat{

    return [NSString stringWithFormat:@"%02zd:%02zd",(int)self.totalTime / 60, (int)self.totalTime % 60];
}
- (NSString *)currentTimeFormat{
    
    return [NSString stringWithFormat:@"%02zd:%02zd",(int)self.currentTime / 60, (int)self.currentTime % 60];
}
- (float)volume{
   return self.player.volume;
}
- (BOOL)muted{

    return self.player.muted;
}
- (float)rate{

    return self.player.rate;
}
- (float)progress{
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}
- (float)loadDataProgress{
    if (self.totalTime == 0) {
        return 0;
    }
    CMTimeRange timeRange = [self.player.currentItem.loadedTimeRanges.lastObject CMTimeRangeValue];
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    return CMTimeGetSeconds(loadTime) / self.totalTime;
    
}
#pragma mark - 通知
- (void)playEnd{

    NSLog(@"播放完成");
    self.state = DYYPlayerStateStopped;
}
- (void)playInterrupt{

    NSLog(@"播放被打断");
    self.state = DYYPlayerStatePause;
}
#pragma mark - KVO
- (void)removeObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"status"]) {
        if ([change[NSKeyValueChangeNewKey] integerValue] == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"加载完毕");
            [self resume];
        }else {
            NSLog(@"加载失败");
            self.state = DYYPlayerStateFailed;
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
    
        BOOL plk = [change[NSKeyValueChangeNewKey] boolValue];
        if (plk) {
            NSLog(@"可以播放");
            if (_isUserPause != YES) {
                [self resume];
            }
        }else {
            self.state = DYYPlayerStateLoading;
        }
        
    }
}
@end
