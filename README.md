# DYYPlayer
音视频播放器 对AVPlayer的封装 支持边播边缓存功能
### demo

![demo](video_demo.gif)

### 播放
```objc
 NSURL *url = [NSURL URLWithString:@"http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];
    [[DYYPlayer sharePlayer] playWithUrl:url isCache:NO];
    self.playerLayer.player = [DYYPlayer sharePlayer].player;
```