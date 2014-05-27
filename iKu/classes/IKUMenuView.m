//
//  IKUMenuView.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUMenuView.h"
#import <UIView+AutoLayout.h>

@interface IKUMenuView ()

@end

@implementation IKUMenuView

- (instancetype)initWithItems:(NSArray*)items
{
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

-(void)setItems:(NSArray *)items {
    if (items != _items) {
        if (_items) {
            [self removeConstraints:self.constraints];
            [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
        }
        _items = items;
        [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = (UIView*)obj;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];
        }];

    }
}

#define MAX_BUTTON_SIZE 64.0f
#define MIN_BUTTON_SIZE 36.0f
#define MIN_BUTTON_PADDING 10.0f

-(void)updateConstraints {
    [super updateConstraints];
//    so first thing: how big do we make our buttons?
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height);
    }
    CGFloat buttonSize, viewHeight, hPadding;
    
    buttonSize = (self.frame.size.width - (MIN_BUTTON_PADDING * (self.items.count + 1))) / self.items.count;
    
    buttonSize = fmin(MAX_BUTTON_SIZE, buttonSize);
    buttonSize = fmax(MIN_BUTTON_SIZE, buttonSize);
    
    viewHeight = buttonSize + (2 * MIN_BUTTON_PADDING);
    hPadding = (self.frame.size.width - (self.items.count * buttonSize)) / (self.items.count + 1);
    
    [self autoSetDimension:ALDimensionWidth toSize:self.superview.bounds.size.width];
    [self autoSetDimension:ALDimensionHeight toSize:viewHeight];
    [self autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];


//manually set widths and heights here so that we can assign priorities
    
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView*)obj;

        NSLayoutConstraint *minWidth = [NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.0f constant:MIN_BUTTON_SIZE];
        minWidth.priority = 1000.0f;

        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:0.0f constant:buttonSize];
        width.priority = 500.0f;
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0f
                                                                   constant:0.0f];
        [self addConstraints:@[minWidth, width, height]];
        
    }];
//    line them up:
    
    __block UIView *firstView = [self.items firstObject];
    [firstView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:hPadding];
    [firstView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    NSArray *offsets = [self offsetsForItemsWithCount:self.items.count];
    
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView*)obj;
        if ([view isEqual:firstView]) {
//            pass
        }else {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:firstView withOffset:hPadding];
            [view autoAlignAxis:ALAxisHorizontal toSameAxisOfView:firstView];
            firstView = view;
            
        }
    }];

}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - helpers

-(NSArray*)offsetsForItemsWithCount:(NSUInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    
}

@end
