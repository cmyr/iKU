//
//  IKUHaikuView.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-23.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHaikuView.h"
#import "IKUHaiku.h"


@implementation IKUHaikuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.numberOfLines = 3;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f];
        NSArray *constraints = @[
                                 [NSLayoutConstraint constraintWithItem:self.textLabel
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0f
                                                               constant:0.0f],
                                 [NSLayoutConstraint constraintWithItem:self.textLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f],
                                 [NSLayoutConstraint constraintWithItem:self.textLabel
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0f
                                                               constant:-20.0f],
                                 [NSLayoutConstraint constraintWithItem:self.textLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0f
                                                               constant:0.0f]
                                 ];

        [self addSubview:self.textLabel];
        [self addConstraints:constraints];
    }
    return self;
}

-(void)setHaiku:(IKUHaiku *)haiku {
    if (haiku != _haiku) {
        _haiku = haiku;
//        layout haiku as needed
        self.textLabel.text = haiku.text;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumScaleFactor = 0.4f;
        
        [self.textLabel sizeToFit];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
