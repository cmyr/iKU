//
//  HaikuStore.h
//  iKu
//
//  Created by Colin Rofls on 2014-06-06.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HaikuStore : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * identifier;

@end
