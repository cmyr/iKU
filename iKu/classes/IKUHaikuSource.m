//
//  IKUHaikuSource.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHaikuSource.h"
#import "IKUHaiku.h"

@interface IKUHaikuSource ()
@property (strong, nonatomic) NSArray* haikuArray;
@property (nonatomic) NSInteger nextIdx;
@end

@implementation IKUHaikuSource

#pragma mark - inits etc

+(instancetype)sharedInstance {
    static IKUHaikuSource *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc]init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nextIdx = -1;
        
    }
    return self;
}

#pragma mark - public
-(IKUHaiku*)nextHaiku {
    IKUHaiku *next = nil;
    self.nextIdx += 1;
    
    if (self.haikuArray.count > self.nextIdx) {
        next = self.haikuArray[self.nextIdx];
    }
    
    return next;
}

#pragma mark - debug stuff

-(void)_setupDebugData {
    NSArray *haikuDicts = [self _debugHaikuFromPlist:nil];
    NSMutableArray *haikuArray = [NSMutableArray array];
    
    [haikuDicts enumerateObjectsWithOptions:0
                                 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     if ([obj isKindOfClass:[NSDictionary class]]) {
                                         IKUHaiku *newHaiku = [[IKUHaiku alloc]initWithDict:obj];
                                         [haikuArray addObject:newHaiku];
                                     }
                                 }];
    self.haikuArray = [haikuArray copy];
}

-(NSArray*)_debugHaikuFromPlist:(NSString*)plistName {
    if (!plistName) {
        plistName = @"testhaiku";
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:plistName ofType:@"plist"];
    NSArray *haikuArray = [[NSArray alloc]initWithContentsOfFile:path];
    if (![haikuArray isKindOfClass:[NSArray class]]) {
        NSLog(@"what we loaded is not an array?");
    }
    return haikuArray;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
