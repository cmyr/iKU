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
#import "IKUSlideGestureRecognizer.h"

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
    NSString *test = @"quite aware we're dying\
    let's pretend just for the night\
    Now, its time to change!";

    [self setText:test];

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
    self.viewOne.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewTwo.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentView = self.viewOne;
    self.nextView = self.viewTwo;
    
    [self.view addSubview:self.viewOne];
    [self.view addSubview:self.viewTwo];
    
    [self setConstraintsForHaikuViews];
    [self prepareNextView];
    
}

#pragma mark - animation and view updating

-(void)prepareNextView {
    IKUHaiku *haiku = [self.haikuSource nextHaiku];
    self.nextView.haiku = nil;
    if (haiku) {
        self.nextView.haiku = haiku;
    }
}

-(void)animateToNextView {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.leftAlignConstraint.constant = -self.currentView.frame.size.width;
                         [self.view layoutIfNeeded];
                         
                     }
                     completion:^(BOOL finished) {
                         IKUHaikuView *nextView = self.currentView;
                         self.currentView = self.nextView;
                         self.nextView = nextView;
                         [self prepareNextView];
                         [self setConstraintsForHaikuViews];
                     }];
}

-(void)animateToOriginalPosition {
//    self.leftAlignConstraint.constant = 0.0f;
//    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
//    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.currentView snapToPoint:self.view.center];
//    snap.damping = 0.5f;
//    [self.animator addBehavior:snap];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.leftAlignConstraint.constant = 0.0f;
                         [self.view layoutIfNeeded];
                     }
                     completion:NULL
     ];
}

//-(void)setConstraintsForDisplayedView:(IKUHaikuView*)mainView nextView:(IKUHaikuView*)nextView {
-(void)setConstraintsForHaikuViews {

    if (self.activeConstraints) {
        [self.view removeConstraints:self.activeConstraints];
    }
    

    NSLayoutConstraint *leftAlignConstraint = [NSLayoutConstraint constraintWithItem:self.currentView
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0f
                                                                            constant:0.0f];
    
    self.activeConstraints = @[leftAlignConstraint,
                                [NSLayoutConstraint constraintWithItem:self.currentView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                            attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.currentView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.currentView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1.0f
                                                           constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.nextView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.currentView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.nextView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.currentView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.nextView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.currentView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0f
                                                             constant:0.0f],
                               [NSLayoutConstraint constraintWithItem:self.nextView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.currentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f constant:0.0f]
                            
                             ];
    [self.view addConstraints:self.activeConstraints];
    self.leftAlignConstraint = leftAlignConstraint;
    [self.view layoutIfNeeded];
}


-(void)setText:(NSString*)text {
    self.currentView.textLabel.text = text;
    self.currentView.textLabel.adjustsFontSizeToFitWidth = YES;
    self.currentView.textLabel.minimumScaleFactor = 0.4f;
    
    [self.currentView.textLabel sizeToFit];
//    [self.currentView updateConstraints];
    
}


#pragma mark - gesture handling


-(void)setupGestureRecognizers {
//    self.swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureDetected:)];
//    self.swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:self.swipe];
    
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
                self.leftAlignConstraint.constant = panDistance;
                [self.view updateConstraintsIfNeeded];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint touchLocation = [self.pan locationInView:self.view];
            CGFloat panDistance = self.initialPanPoint.x - touchLocation.x;
            if (panDistance > self.currentView.frame.size.width * 0.45f) {
                [self animateToNextView];
            }else {
                [self animateToOriginalPosition];
            }
        }
        default:
            break;
    }
}


-(void)swipeGestureDetected:(id)sender {
    [self animateToNextView];
    [self prepareNextView];
//    IKUHaiku *haiku = [self.haikuSource nextHaiku];
//    if (haiku) {
//        [self displayHaiku:haiku];
//    }
}

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
