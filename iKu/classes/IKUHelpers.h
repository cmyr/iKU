//
//  IKUHelpers.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKUHelpers : NSObject

extern CGFloat randomFloat(CGFloat scale);
extern CGFloat wraparoundFloat(CGFloat aFloat);
extern CGFloat bouncingFloat(CGFloat aFloat, CGFloat floor, CGFloat rate, BOOL isRandom);

@end
