//
//  NSURL+Streaming.m
//  DYYPlayer
//
//  Created by yang on 2017/7/10.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "NSURL+Agreement.h"

@implementation NSURL (Agreement)
- (NSURL *)streamingUrl{

    NSURLComponents *components = [NSURLComponents componentsWithString:self.absoluteString];
    components.scheme = @"sreaming";
    return components.URL;
}
- (NSURL *)httpUrl{
    
    NSURLComponents *components = [NSURLComponents componentsWithString:self.absoluteString];
    components.scheme = @"http";
    return components.URL;
}
@end
