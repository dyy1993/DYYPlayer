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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)play:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    [[DYYPlayer sharePlayer] playWithUrl:url];
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
    [[DYYPlayer sharePlayer] setMute:sender.selected];
}
- (IBAction)volume:(UISlider *)sender {
    [[DYYPlayer  sharePlayer] setVolume:sender.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
