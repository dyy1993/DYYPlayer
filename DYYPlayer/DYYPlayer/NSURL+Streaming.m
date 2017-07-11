//
//  NSURL+Streaming.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "NSURL+Streaming.h"

@implementation NSURL (Streaming)
- (NSURL *)streamingUrl{

    NSURLComponents *components = [NSURLComponents componentsWithString:self.absoluteString];
    components.scheme = @"sreaming";
    return components.URL;
}

@end
