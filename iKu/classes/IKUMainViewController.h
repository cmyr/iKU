//
//  IKUMainViewController.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>


CGFloat restPointForVelocity(CGFloat position, CGFloat velocity, CGFloat damping);

UIColor* colorBetweenColors(UIColor *color1, UIColor *color2, CGFloat percentDistance);
void    debugPrintColor(UIColor* color);

@interface IKUMainViewController : UIViewController

@end
