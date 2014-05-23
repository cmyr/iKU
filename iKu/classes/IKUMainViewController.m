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
#import <AVFoundation/AVFoundation.h>

@interface IKUMainViewController ()
@property (strong, nonatomic) IKUHaikuSource* haikuSource;
@property (weak, nonatomic) IBOutlet UILabel *haikuLabel;
@property (strong, nonatomic) UISwipeGestureRecognizer* swipe;
@property (strong, nonatomic) IKUHaiku* haiku;
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

    NSString *test = @"quite aware we're dying\
    let's pretend just for the night\
    Now, its time to change!";
    
    [self setText:test];
    [self setupGestureRecognizers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setText:(NSString*)text {
    self.haikuLabel.text = text;
    self.haikuLabel.adjustsFontSizeToFitWidth = YES;
    self.haikuLabel.minimumScaleFactor = 0.4f;
    
    [self.haikuLabel sizeToFit];
    
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
