//
//  ViewController.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "ViewController.h"
#import "DYYPlayer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UISlider *progress;

@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *loadDataProgress;

@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIView *playerView;

@end

@implementation ViewController
-(NSTimer *)timer{

    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updata) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timer];
      // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:self.playerLayer];
    self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
}
- (void)updata{
//    NSLog(@"%zd",[DYYPlayer sharePlayer].state);
    
    self.currentTime.text = [DYYPlayer sharePlayer].currentTimeFormat;
    self.totalTime.text = [DYYPlayer sharePlayer].totalTimeFormat;
    self.progress.value = [DYYPlayer sharePlayer].progress;
    self.muteBtn.selected = [DYYPlayer sharePlayer].muted;
    self.volumProgress.value = [DYYPlayer sharePlayer].volume;
    self.loadDataProgress.progress = [DYYPlayer sharePlayer].loadDataProgress;

}

- (IBAction)play:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    [[DYYPlayer sharePlayer] playWithUrl:url isCache:YES];
    self.playerLayer.player = [DYYPlayer sharePlayer].player;
    
}
- (IBAction)pauseOrContinue:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[DYYPlayer sharePlayer] pause];
    }else {
        [[DYYPlayer sharePlayer] resume];
    }
}
- (IBAction)stop:(id)sender {
    [[DYYPlayer  sharePlayer] stop];
}
- (IBAction)fastForward:(id)sender {
    [[DYYPlayer sharePlayer] seekWithTimeDiffer:15];
}
- (IBAction)progress:(UISlider *)sender {
    [[DYYPlayer sharePlayer] seekWithProgress:sender.value];
}
- (IBAction)rate:(id)sender {
    [[DYYPlayer sharePlayer] setRate:1.5];
}
- (IBAction)mute:(UIButton *)sender {
    sender.selected = !sender.selected;
    [DYYPlayer sharePlayer].muted = sender.selected;
}
- (IBAction)volume:(UISlider *)sender {
    [[DYYPlayer  sharePlayer] setVolume:sender.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
