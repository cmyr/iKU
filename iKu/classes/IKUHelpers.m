//
//  IKUHelpers.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHelpers.h"

@implementation IKUHelpers

CGFloat randomFloat(CGFloat scale) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(time(0));
    });
    
    double r = drand48();
    return (CGFloat)r * scale;
}


CGFloat wraparoundFloat(CGFloat aFloat) {
    if (aFloat > 1.0f) {
        aFloat -= 1.0f;
    }
    return aFloat;
}


CGFloat bouncingFloat(CGFloat aFloat, CGFloat floor, CGFloat rate, BOOL isRandom) {
    static BOOL reverse;
    CGFloat newValue;
    CGFloat change = isRandom ? randomFloat(rate) : rate;
    
    newValue = reverse ? aFloat - change : aFloat + change;
    if (newValue > 1.0f || newValue < floor) {
        reverse = !reverse;
        newValue = reverse ? aFloat - change : aFloat + change;
    }
    if (floor) {
        newValue = fmaxf(newValue, floor);
    }
    return newValue;
}

@end
