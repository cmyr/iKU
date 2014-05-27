//
//  IKUMainViewController.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUMainViewController.h"
#import "IKUHaikuSource.h"
#import "IKUHaiku.h"
#import "IKUHaikuView.h"
#import "IKUMenuView.h"
#import "DKCircleButton.h"
#import "IKUHelpers.h"

#import <UIView+AutoLayout.h>

@interface IKUMainViewController ()

@property (strong, nonatomic) IKUHaikuSource* haikuSource;
@property (strong, nonatomic, readonly) IKUHaikuView* viewOne;
@property (strong, nonatomic, readonly) IKUHaikuView* viewTwo;
@property (weak, nonatomic) IKUHaikuView *currentView;
@property (weak, nonatomic) IKUHaikuView *nextView;

@property (strong, nonatomic) IKUMenuView *topMenu;
@property (strong, nonatomic) UIPanGestureRecognizer* pan;
@property (nonatomic) CGPoint initialPanPoint;

@end

@implementation IKUMainViewController

#pragma mark - init and instantiations

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.haikuSource = [IKUHaikuSource sharedInstance];
    [self.haikuSource _setupDebugData];
    [self setupGestureRecognizers];
    [self setupInitialViews];
}
-(void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(animateToNextView:) withObject:nil afterDelay:0.2f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupInitialViews {
    _viewOne = [[IKUHaikuView alloc]init];
    _viewTwo = [[IKUHaikuView alloc]init];
    
    self.currentView = self.viewOne;
    self.nextView = self.viewTwo;
    self.currentView.preferredBackgroundColor = [UIColor whiteColor];
    
//    [self.currentView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.277 blue:0.277 alpha:1.000]];
//    [self.nextView setBackgroundColor:[UIColor colorWithRed:0.000 green:0.355 blue:1.000 alpha:1.000]];
    
    [self.view addSubview:self.viewOne];
    [self.view addSubview:self.viewTwo];
    [self setupTopMenu];
    
    [self layoutHaikuViews];
    [self prepareNextView];
    
}

-(void)setupTopMenu {
    DKCircleButton *b1 = [[DKCircleButton alloc]init];
    [b1 setTitle:@"b1" forState:UIControlStateNormal];
    b1.animateTap = NO;
    [b1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    b1.tag = 69;
    
    DKCircleButton *b2 = [[DKCircleButton alloc]init];
    [b2 setTitle:@"b2" forState:UIControlStateNormal];
    b2.animateTap = NO;
    [b2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    DKCircleButton *b3 = [[DKCircleButton alloc]init];
    [b3 setTitle:@"b3" forState:UIControlStateNormal];
    b3.animateTap = NO;
    
    
    self.topMenu = [[IKUMenuView alloc]initWithItems:@[b1, b2] menuPosition:IKUMenuPositionTop];
    self.topMenu.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.topMenu];
//    self.topMenu.backgroundColor = [UIColor colorWithRed:0.000 green:0.358 blue:0.000 alpha:1.000];
    
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self layoutHaikuViews];
                         } completion:NULL];
}

#pragma mark - animation and view updating

-(void)prepareNextView {
    IKUHaiku *haiku = [self.haikuSource nextHaiku];
    self.nextView.haiku = nil;
    if (haiku) {
        self.nextView.haiku = haiku;
        UIColor *nextColor = [self colorPickedFromColor:self.currentView.preferredBackgroundColor];
        self.nextView.preferredBackgroundColor = nextColor;

    }
}

-(void)animateToNextView:(CGFloat)velocity {
    [self.view layoutIfNeeded];
    CGFloat distanceToTravel = self.nextView.center.x - self.view.bounds.size.width / 2;
    NSTimeInterval animationDuration = distanceToTravel / fabsf(velocity);
//    set max time interval
    animationDuration = fminf(animationDuration, 0.3f);
    
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.backgroundColor = self.nextView.preferredBackgroundColor;
                         debugPrintColor(self.view.backgroundColor);
                         self.currentView.frame = CGRectOffset(self.view.bounds, -self.view.bounds.size.width, 0);
                         self.nextView.frame = self.view.bounds;
                         
                     }
                     completion:^(BOOL finished) {
                         IKUHaikuView *nextView = self.currentView;
                         self.currentView = self.nextView;
                         self.nextView = nextView;
                         [self prepareNextView];
                         [self layoutHaikuViews];
//                         [self setConstraintsForHaikuViews];
                     }];

}

#define DEFAULT_ANIMATION_VELOCITY 200.0f

-(void)animateToOriginalPosition:(CGFloat)velocity {
    NSTimeInterval animationDuration;

    if (velocity < DEFAULT_ANIMATION_VELOCITY) {
        velocity = DEFAULT_ANIMATION_VELOCITY;
    }
    CGFloat distanceToTravel = (self.view.bounds.size.width / 2) - self.currentView.center.x;
    animationDuration = distanceToTravel / velocity;

//    set a max animation duration
    animationDuration = fminf(animationDuration, 0.3f);

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.backgroundColor = self.currentView.preferredBackgroundColor;
                         self.currentView.frame = self.view.bounds;
                         self.nextView.frame = CGRectOffset(self.currentView.frame, self.currentView.bounds.size.width, 0);
//                         self.leftAlignConstraint.constant = 0.0f;
//                         [self.view layoutIfNeeded];
                     }
                     completion:NULL
     ];
}

//-(void)setConstraintsForDisplayedView:(IKUHaikuView*)mainView nextView:(IKUHaikuView*)nextView {
-(void)layoutHaikuViews {

    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        self.currentView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }else {
        self.currentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.nextView.frame = CGRectOffset(self.currentView.frame, self.currentView.frame.size.width, 0);
}




#pragma mark - gesture handling

#define DEFAULT_PAN_DAMPING 0.2f

-(void)setupGestureRecognizers {
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:self.pan];
}

-(void)panGesture:(UIPanGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.initialPanPoint = [self.pan locationInView:self.view];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint touchLocation = [self.pan locationInView:self.view];
            CGFloat panDistance = touchLocation.x  - self.initialPanPoint.x;
            if (panDistance < 0) {
//                we use bounds.size.{} / 2 because center doesn't change when rotated
                self.currentView.center = CGPointMake((self.view.bounds.size.width / 2) + panDistance,
                                                      (self.view.bounds.size.height / 2));
                self.nextView.frame = CGRectOffset(self.currentView.frame, self.currentView.bounds.size.width, 0);
//                [self.view updateConstraintsIfNeeded];
                CGFloat panPercent = panDistance / self.view.bounds.size.width;
                self.view.backgroundColor = colorBetweenColors(self.currentView.preferredBackgroundColor,
                                                               self.nextView.preferredBackgroundColor,
                                                               panPercent);
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint touchLocation = [self.pan locationInView:self.view];
            CGFloat panDistance = touchLocation.x - self.initialPanPoint.x;
            CGFloat hVelocity = [gesture velocityInView:self.view].x;
            CGFloat inertialModifier =  restPointForVelocity(0.0f, hVelocity, DEFAULT_PAN_DAMPING);
            CGFloat restPoint = panDistance + inertialModifier;
//            NSLog(@"distance: %f, velocity: %f, modifier: %f, restpoint: %f", panDistance, hVelocity, inertialModifier, restPoint);
            
            if (restPoint < (0.0f - self.currentView.bounds.size.width * 0.5f)) {
                [self animateToNextView:hVelocity];
            }else {
                [self animateToOriginalPosition:hVelocity];
            }
        }
        default:
            break;
    }
}


#pragma mark - debug

-(void)buttonTapped:(UIButton*)sender {
    if (sender.tag == 69) {
        DKCircleButton *b4 = [[DKCircleButton alloc]init];
        [b4 setTitle:@"b4" forState:UIControlStateNormal];
        b4.animateTap = NO;
        self.topMenu.items = [self.topMenu.items arrayByAddingObject:b4];
    }else {
        NSUInteger count = self.topMenu.items.count;
        if (count > 1) {
            self.topMenu.items = [self.topMenu.items subarrayWithRange:NSMakeRange(0, count-1)];
        }

    }
}
#pragma mark - helpers etc


-(UIColor*)randomishColor {
    CGFloat hue = randomFloat(1.0f);
    CGFloat bright = 0.8 + randomFloat(0.2f);
    CGFloat sat = 0.6 + randomFloat(0.4f);
    
    UIColor *randomColor = [UIColor colorWithHue:hue
                                      saturation:sat
                                      brightness:bright
                                           alpha:1.0];
    return randomColor;
}
#define BOUNCE_FLOOR 0.3f
-(UIColor*)colorPickedFromColor:(UIColor*)color {
    CGFloat hue, sat, bright, alpha;
    [color getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    hue = wraparoundFloat(hue + randomFloat(0.04f));
    sat = bouncingFloat(sat, BOUNCE_FLOOR, 0.02f, YES);
    bright = 0.7f + randomFloat(0.3f);
    return [UIColor colorWithHue:hue saturation:sat brightness:bright alpha:1.0f];
    
}


CGFloat restPointForVelocity(CGFloat position, CGFloat velocity, CGFloat damping) {
    BOOL reverse = (velocity > 0.0f) ? NO : YES;
    velocity = fabsf(velocity);
    if (velocity > 1.0f) {
        velocity = velocity - (velocity * ( 1 - damping));
        position = reverse ? position - velocity : position + velocity;
        return restPointForVelocity(position, velocity, damping);
    }
    return position;
}

UIColor* colorBetweenColors(UIColor *color1, UIColor *color2, CGFloat percentDistance) {
    CGFloat r1, r2, g1, g2, b1, b2, a1, a2, rdiff, gdiff, bdiff, adiff;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    rdiff = (r1 - r2) * percentDistance;
    gdiff = (g1 - g2) * percentDistance;
    bdiff = (b1 - b2) * percentDistance;
    adiff = (a1 - a2) * percentDistance;
    return [UIColor colorWithRed:r1+rdiff green:g1+gdiff blue:b1+bdiff alpha:a1+adiff];
}

void debugPrintColor(UIColor* color) {
    CGFloat h, s, b;
    [color getHue:&h saturation:&s brightness:&b alpha:NULL];
    NSLog(@"HSB: %f / %f /%f", h, s, b);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

