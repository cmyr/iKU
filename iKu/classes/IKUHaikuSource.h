//
//  IKUHaikuSource.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IKUHaiku;
@interface IKUHaikuSource : NSObject

+(instancetype)sharedInstance;
-(IKUHaiku*)nextHaiku;

-(void)_setupDebugData;
@end

