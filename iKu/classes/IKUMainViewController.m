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

@interface IKUMainViewController ()

@property (strong, nonatomic) IKUHaikuSource* haikuSource;
@property (strong, nonatomic, readonly) IKUHaikuView* viewOne;
@property (strong, nonatomic, readonly) IKUHaikuView* viewTwo;
@property (weak, nonatomic) IKUHaikuView *currentView;
@property (weak, nonatomic) IKUHaikuView *nextView;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipe;
@property (strong, nonatomic) UIPanGestureRecognizer* pan;

@property (strong, nonatomic) UIDynamicAnimator* animator;
@property (strong, nonatomic) NSArray* activeConstraints;
@property (weak, nonatomic) NSLayoutConstraint *leftAlignConstraint;

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
    
    //
//    NSString *test = @"quite aware we're dying\
//    let's pretend just for the night\
//    Now, its time to change!";
//
//    [self setText:test];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupInitialViews {
    _viewOne = [[IKUHaikuView alloc]init];
    _viewTwo = [[IKUHaikuView alloc]init];
//    self.viewOne.translatesAutoresizingMaskIntoConstraints = NO;
//    self.viewTwo.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentView = self.viewOne;
    self.nextView = self.viewTwo;
    
//    [self.currentView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.277 blue:0.277 alpha:1.000]];
//    [self.nextView setBackgroundColor:[UIColor colorWithRed:0.000 green:0.355 blue:1.000 alpha:1.000]];
    [self.view addSubview:self.viewOne];
    [self.view addSubview:self.viewTwo];
    
//    [self setConstraintsForHaikuViews];
    [self layoutHaikuViews];
    [self prepareNextView];
    
}

#pragma mark - animation and view updating

-(void)prepareNextView {
    IKUHaiku *haiku = [self.haikuSource nextHaiku];
    self.nextView.haiku = nil;
    if (haiku) {
        self.nextView.haiku = haiku;
        self.nextView.preferredBackgroundColor = [self randomishColor];
    }
}

-(void)animateToNextView:(CGFloat)velocity {
    [self.view layoutIfNeeded];
    CGFloat distanceToTravel = self.nextView.center.x - self.view.center.x;
    NSTimeInterval animationDuration = distanceToTravel / fabsf(velocity);
//    set max time interval
    animationDuration = fminf(animationDuration, 0.3f);
    
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.backgroundColor = self.nextView.preferredBackgroundColor;
//                         self.leftAlignConstraint.constant = -self.currentView.frame.size.width;
//                         [self.view layoutIfNeeded];
                         self.currentView.center = CGPointMake(self.view.center.x - self.view.frame.size.width,
                                                               self.view.center.y);
                         self.nextView.center = self.view.center;
                         
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
    CGFloat distanceToTravel = self.view.center.x - self.currentView.center.x;
    animationDuration = distanceToTravel / velocity;

//    set a max animation duration
    animationDuration = fminf(animationDuration, 0.3f);

    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.backgroundColor = self.currentView.preferredBackgroundColor;
                         self.currentView.center = self.view.center;
                         self.nextView.frame = CGRectOffset(self.currentView.frame, self.currentView.frame.size.width, 0);
//                         self.leftAlignConstraint.constant = 0.0f;
//                         [self.view layoutIfNeeded];
                     }
                     completion:NULL
     ];
}

//-(void)setConstraintsForDisplayedView:(IKUHaikuView*)mainView nextView:(IKUHaikuView*)nextView {
-(void)layoutHaikuViews {
    self.currentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
                self.currentView.center = CGPointMake(self.view.center.x + panDistance, self.view.center.y);
                self.nextView.frame = CGRectOffset(self.currentView.frame, self.currentView.frame.size.width, 0);
//                [self.view updateConstraintsIfNeeded];
                CGFloat panPercent = panDistance / self.view.frame.size.width;
                self.view.backgroundColor = [self colorWithDistance:panPercent
                                                       betweenColor:self.currentView.preferredBackgroundColor
                                                           andColor:self.nextView.preferredBackgroundColor];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint touchLocation = [self.pan locationInView:self.view];
            CGFloat panDistance = touchLocation.x - self.initialPanPoint.x;
            CGFloat hVelocity = [gesture velocityInView:self.view].x;
            CGFloat inertialModifier =  restPointForVelocity(0.0f, hVelocity, DEFAULT_PAN_DAMPING);
            CGFloat restPoint = panDistance + inertialModifier;
            NSLog(@"distance: %f, velocity: %f, modifier: %f, restpoint: %f",panDistance, hVelocity, inertialModifier, restPoint);
            
            if (restPoint < (0.0f - self.currentView.frame.size.width * 0.5f)) {
                [self animateToNextView:hVelocity];
            }else {
                [self animateToOriginalPosition:hVelocity];
            }
        }
        default:
            break;
    }
}


//-(void)swipeGestureDetected:(id)sender {
//    [self animateToNextView];
//    [self prepareNextView];
////    IKUHaiku *haiku = [self.haikuSource nextHaiku];
////    if (haiku) {
////        [self displayHaiku:haiku];
////    }
//}

#pragma mark - helpers etc

-(UIColor*)colorWithDistance:(CGFloat)percentDistance betweenColor:(UIColor*)color1 andColor:(UIColor*)color2 {
    CGFloat h1, s1, b1, a1, h2, s2, b2, a2, hdiff, sdiff, bdiff, adiff;
    [color1 getHue:&h1 saturation:&s1 brightness:&b1 alpha:&a1];
    [color2 getHue:&h2 saturation:&s2 brightness:&b2 alpha:&a2];

    hdiff = (h1 - h2) * percentDistance;
    sdiff = (s1 - s2) * percentDistance;
    bdiff = (b1 - b2) * percentDistance;
    adiff = (a1 - a2) * percentDistance;

    return [UIColor colorWithHue:h1+hdiff saturation:s1+sdiff brightness:b1+bdiff alpha:a1+adiff];
    
    
}

-(UIColor*)randomishColor {
    CGFloat hue = randomFloat();
    CGFloat bright = 0.5 + (randomFloat() *0.5);
    CGFloat sat = 0.5 + (randomFloat() *0.5);
    
    UIColor *randomColor = [UIColor colorWithHue:hue
                                      saturation:sat
                                      brightness:bright
                                           alpha:1.0];
    return randomColor;
}


CGFloat randomFloat() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(time(0));
    });
    
    double r = drand48();
    return (CGFloat)r;
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

