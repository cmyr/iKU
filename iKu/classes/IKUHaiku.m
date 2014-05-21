    //
//  IKUHaiku.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHaiku.h"

@interface IKUHaiku ()
@property (strong, nonatomic, readwrite) NSString* text;
@end


@implementation IKUHaiku

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
    }
    
    return self;
}
@end
