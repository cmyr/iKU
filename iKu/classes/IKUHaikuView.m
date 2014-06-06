//
//  IKUHaikuView.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-23.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHaikuView.h"
#import "IKUHaiku.h"
#import <UIView+AutoLayout.h>

@interface IKUHaikuView ()
@property (strong, nonatomic) UILabel* starLabel;
@end

@implementation IKUHaikuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.starLabel = [[UILabel alloc]init];
        self.starLabel.text = @"★";
        self.starLabel.font = [UIFont systemFontOfSize:200.0f];
        self.starLabel.hidden = YES;
        self.starLabel.alpha = 0.0f;
        self.starLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.starLabel];
        
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.numberOfLines = 3;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:32.0f];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        

    }
    return self;
}

#define SIDE_PADDING 20.0f
-(void)updateConstraints {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, SIDE_PADDING, 0, SIDE_PADDING);
    [self.textLabel autoPinEdgesToSuperviewEdgesWithInsets:insets];
    [self.starLabel autoCenterInSuperview];
    [super updateConstraints];
}

-(void)setHaiku:(IKUHaiku *)haiku {
    if (haiku != _haiku) {
        _haiku = haiku;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews {
    self.textLabel.text = self.haiku.text;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.4f;
    [self.textLabel sizeToFit];
    [self starHaiku:self.haiku.isStarred animated:NO];
    [super layoutSubviews];
}

-(void)starHaiku:(BOOL)visible animated:(BOOL)animated {
    if (animated) {
        self.starLabel.hidden = NO;
        self.haiku.starred = visible;
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self _showStarLabel:visible];
                         } completion:^(BOOL finished) {
                             self.starLabel.hidden = !visible;
                         }];
    }else{
        [self _showStarLabel:visible];
        self.starLabel.hidden = !visible;
    }
}

-(void)_showStarLabel:(BOOL)visible {
    if (visible) {
        self.starLabel.alpha = 0.1f;
    }else {
        self.starLabel.alpha = 0.0f;
    }
    
}

-(UIColor*)preferredBackgroundColor {
    if (!_preferredBackgroundColor) {
        _preferredBackgroundColor = [UIColor whiteColor];
    }
    return _preferredBackgroundColor;
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
