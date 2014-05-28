//
//  IKUMenuView.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-27.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUMenuView.h"
#import "IKUHelpers.h"

#import <UIView+AutoLayout.h>

@interface IKUMenuView ()
@property (nonatomic) BOOL shouldUpdateConstraints;
@property (nonatomic, assign) IKUMenuPosition menuPosition;
@property (weak, nonatomic) NSLayoutConstraint* edgeConstraint;
@property (strong, nonatomic) NSMutableArray* constraintsWithPadding;
@end

@implementation IKUMenuView

#pragma mark - init and setters/getters

- (instancetype)initWithItems:(NSArray*)items menuPosition:(IKUMenuPosition)menuPosition
{
    self = [super init];
    if (self) {
        self.items = items;
        self.shouldUpdateConstraints = YES;
        self.menuPosition = menuPosition;
//        self.backgroundColor =[UIColor colorWithWhite:0.0f alpha:0.3f];
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
        self.shouldUpdateConstraints = YES;
        }
}




#pragma mark - layout

#define MAX_BUTTON_SIZE 64.0f
#define MIN_BUTTON_SIZE 24.0f
#define MIN_BUTTON_PADDING 4.0f
#define EXTERNAL_PADDING 20.0f


-(void)updateConstraints {
    
    if (!self.shouldUpdateConstraints) {
        [super updateConstraints];
        return;
    }
    
    [self removeConstraints:self.constraints];
//    so first thing: how big do we make our buttons?
    if (CGRectIsEmpty(self.frame)) {
        self.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height);
    }
    CGFloat buttonSize, viewHeight, hPadding;
    
    CGFloat spaceForPadding = (MIN_BUTTON_PADDING * self.items.count + 1);
    
    buttonSize = (self.frame.size.width - spaceForPadding) / self.items.count;
    
//    sane values plz
    buttonSize = fmin(MAX_BUTTON_SIZE, buttonSize);
    buttonSize = fmax(MIN_BUTTON_SIZE, buttonSize);
    
    viewHeight = buttonSize * 2 + (2 * EXTERNAL_PADDING);
    hPadding = (self.frame.size.width - (self.items.count * buttonSize)) / (self.items.count + 1);
    
    [self autoSetDimension:ALDimensionHeight toSize:viewHeight];
    [self autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    ALEdge pinEdge = (self.menuPosition == IKUMenuPositionTop) ? ALEdgeTop : ALEdgeBottom;
    self.edgeConstraint = [self autoPinEdgeToSuperviewEdge:pinEdge withInset:0.0f];


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
    
//    store button constraints; we set their paddings in layoutsubviews
    
   self.constraintsWithPadding = [NSMutableArray array];

    __block UIView *firstView = [self.items firstObject];
        [self.constraintsWithPadding addObject:
         [firstView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:hPadding]];

    
//    [firstView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    

    NSArray *offsetModifiers = [self offsetsForItemsWithCount:self.items.count];
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView*)obj;
        
//        first view doesn't need horizonal pinning
        if (![view isEqual:firstView]) {
//          NSLayoutConstraint * layoutConstraint = [NSLayoutConstraint constraintWithItem:view
//                                                                               attribute:NSLayoutAttributeLeft
//                                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                                                                  toItem:firstView
//                                                                               attribute:NSLayoutAttributeRight
//                                                                              multiplier:1.0f
//                                                                                constant:hPadding];
//            
//
//            [self addConstraint:layoutConstraint];
            [self.constraintsWithPadding addObject:
             [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:firstView withOffset:hPadding]];
        }

        //        pin height based on calculated offset;
        CGFloat offsetModifier = [offsetModifiers[idx]floatValue];
        CGFloat offset = EXTERNAL_PADDING + buttonSize - (buttonSize * offsetModifier);
        if (self.menuPosition == IKUMenuPositionTop) {
            [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:offset];
        }else{
            [view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-offset];
        }

        firstView = view;
        
    }];
    self.shouldUpdateConstraints = NO;
    [super updateConstraints];
}

-(void)layoutSubviews {
//    set button paddings (for autorotation, e.g.)
    
    CGFloat buttonSize, viewHeight, hPadding;
    
    CGFloat spaceForPadding = (MIN_BUTTON_PADDING * self.items.count + 1);
    buttonSize = (self.frame.size.width - spaceForPadding) / self.items.count;
    
    //    sane values plz
    buttonSize = fmin(MAX_BUTTON_SIZE, buttonSize);
    buttonSize = fmax(MIN_BUTTON_SIZE, buttonSize);
    viewHeight = buttonSize * 2 + (2 * EXTERNAL_PADDING);
    
    hPadding = (self.frame.size.width - (self.items.count * buttonSize)) / (self.items.count + 1);
    
    [self.constraintsWithPadding enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint = (NSLayoutConstraint*)obj;
        constraint.constant = hPadding;
    }];
    
    [super layoutSubviews];
}

#pragma mark - public API
-(void)setVisible:(BOOL)visible {
    _visible = visible;
    if (visible) {
        self.alpha = 1.0f;
        self.edgeConstraint.constant = 0.0f;
    }else {
        self.alpha = 0.0f;
        CGFloat offset = (self.menuPosition == IKUMenuPositionTop) ? -self.bounds.size.height : self.bounds.size.height;
        self.edgeConstraint.constant = offset;
    }
}

-(void)setVisible:(BOOL)visible animated:(BOOL)animated {
    if (animated) {
        [self.superview layoutIfNeeded];
        
        if (visible) {
            self.hidden = NO;
        }
        
        [UIView animateWithDuration:0.5f
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             self.visible = visible;
                             [self.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             self.hidden = !visible;
                         }];
        
    } else {
        self.visible = visible;
        self.hidden = !visible;
    }
    
}
#pragma mark - helpers
/**
 returns an array of @(floats) used to determine y-pos of menu items
 */
-(NSArray*)offsetsForItemsWithCount:(NSUInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    
    BOOL oddNumber = (BOOL)(count % 2);
    CGFloat offsetCount = (count / 2) + (count % 2);
    CGFloat rateOfChange = 1.0f / offsetCount;
    CGFloat value = 0.0f;
    for (int i = 0; i < count; i++) {
        value = bouncingFloat(value, 0.0f, rateOfChange, NO);
        [array addObject:@(value)];
        if (value >= 1.0f && !oddNumber) {
            [array addObject:@(value)];
            ++i;
        }
    }
    
    return [array copy];
    
}

@end
