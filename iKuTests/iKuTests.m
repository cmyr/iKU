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


@interface iKuTests : XCTestCase
@property (strong, nonatomic) IKUHaikuSource* haikuSource;
@end

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

@end
