//
//  IKUMenuView.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, IKUMenuPosition) {
    IKUMenuPositionTop = 1,
    IKUMenuPositionBottom = 2
};

@interface IKUMenuView : UIView
@property (strong, nonatomic) NSArray* items;
@property (nonatomic, readonly) IKUMenuPosition menuPosition;

-(instancetype)initWithItems:(NSArray*)items menuPosition:(IKUMenuPosition)menuPosition;


@end
