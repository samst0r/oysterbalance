//
//  UIColor+Colors.m
//  OysterBalance
//
//  Created by Sam Ward on 09/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)activeColor {
    
    return [UIColor redColor];
}
@end
