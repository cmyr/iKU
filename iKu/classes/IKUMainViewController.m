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
@property (strong, nonatomic) IKUHaiku* haiku;
@property (strong, nonatomic) NSArray* activeConstraints;
@end

@implementation IKUMainViewController

#pragma mark - init and instantiations

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
    
    self.viewOne.backgroundColor = [UIColor colorWithRed:1.000 green:0.678 blue:0.000 alpha:1.000];
    self.viewTwo.backgroundColor = [UIColor colorWithRed:0.000 green:0.308 blue:1.000 alpha:1.000];
    
    [self setConstraintsForDisplayedView:self.viewOne
                                nextView:self.viewTwo];
    [self.view updateConstraints];
    
}

#pragma mark - animation and view updating

-(void)displayHaiku:(IKUHaiku*)haiku {
    self.haiku = haiku;
    [self setText:haiku.text];
    
}

#pragma mark - gesture handling


-(void)setupGestureRecognizers {
    self.swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureDetected:)];
    self.swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipe];
}


-(void)swipeGestureDetected:(id)sender {
    IKUHaiku *haiku = [self.haikuSource nextHaiku];
    if (haiku) {
        [self displayHaiku:haiku];
    }
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
