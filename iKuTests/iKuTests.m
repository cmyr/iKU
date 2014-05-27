//
//  iKuTests.m
//  iKuTests
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IKUHaiku.h"
#import "IKUHaikuSource.h"

#import "IKUHelpers.h"

//#import "IKUHaikuViewController.h"


@interface iKuTests : XCTestCase
@property (strong, nonatomic) IKUHaikuSource* haikuSource;
@end

//@interface IKUMenuView (Private)
//-(NSArray*)offsetsForItemsWithCount:(NSUInteger)count;
//@end

@implementation iKuTests

- (void)setUp
{
    [super setUp];
    self.haikuSource = [IKUHaikuSource sharedInstance];
    [self.haikuSource _setupDebugData];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    IKUHaiku *h = [self.haikuSource nextHaiku];
    XCTAssert(h, @"failed to return first haiku");
}

CGFloat travelDistanceForVelocity(CGFloat distance, CGFloat velocity, CGFloat damping) {
    velocity = fabsf(velocity);
    if (velocity > 1.0f) {
        velocity = velocity - (velocity * ( 1 - damping));
        distance += velocity;
        return travelDistanceForVelocity(distance, velocity, damping);
    }
    return distance;
}

-(void)testVelocity {
    CGFloat travel = travelDistanceForVelocity(0.0f, 2000.0f, 0.6f);
    NSLog(@"travel = %f", travel);
    travel = travelDistanceForVelocity(0.0f, 1000.0f, 0.9f);
    NSLog(@"travel = %f", travel);
    travel = travelDistanceForVelocity(0.0f, 30.0f, 0.6f);
    NSLog(@"travel = %f", travel);
}


-(void)testMenuStuff {

    NSArray *test1 = [self offsetsForItemsWithCount:2];
    NSArray *test2 = [self offsetsForItemsWithCount:3];
    NSArray *test3 = [self offsetsForItemsWithCount:4];
    NSArray *test4 = [self offsetsForItemsWithCount:5];
    NSArray *test5 = [self offsetsForItemsWithCount:6];
    
    
}

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
