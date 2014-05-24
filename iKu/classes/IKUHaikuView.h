//
//  IKUHaikuView.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-23.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IKUHaiku;

@interface IKUHaikuView : UIView
@property (strong, nonatomic) IKUHaiku* haiku;
@property (strong, nonatomic) UILabel* textLabel;
@end
