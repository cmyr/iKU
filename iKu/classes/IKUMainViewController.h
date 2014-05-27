//
//  IKUMainViewController.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>


CGFloat restPointForVelocity(CGFloat position, CGFloat velocity, CGFloat damping);
CGFloat randomFloat(CGFloat scale);
UIColor* colorBetweenColors(UIColor *color1, UIColor *color2, CGFloat percentDistance);
CGFloat wraparoundFloat(CGFloat aFloat);
void    debugPrintColor(UIColor* color);

@interface IKUMainViewController : UIViewController

@end
