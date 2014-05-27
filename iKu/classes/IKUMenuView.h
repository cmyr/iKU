//
//  IKUMenuView.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKUMenuView : UIView
@property (strong, nonatomic) NSArray* items;
-(instancetype)initWithItems:(NSArray*)items;


@end
