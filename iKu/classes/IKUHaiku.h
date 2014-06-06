//
//  IKUHaiku.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKUHaiku : NSObject

@property (strong, nonatomic, readonly) NSString* text;
@property (strong, nonatomic, readonly) NSNumber* identifier;
@property (nonatomic, getter = isStarred) BOOL starred;

-(instancetype)initWithDict:(NSDictionary*)dict;

@end
