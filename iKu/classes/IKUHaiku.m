    //
//  IKUHaiku.m
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import "IKUHaiku.h"
#import "IKUAppDelegate.h"
#import "HaikuStore.h"


@interface IKUHaiku ()

@property (strong, nonatomic, readwrite) NSString* text;
@property (strong, nonatomic, readwrite) NSNumber* identifier;
@end


@implementation IKUHaiku

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
        self.identifier = dict[@"identifier"];
    }
    
    return self;
}

-(void)setStarred:(BOOL)starred {
    if (starred != _starred) {
        _starred = starred;
        if (starred) {
            [self addToLocalStore];
        }else {
            [self removeFromLocalStore];
        }
    }
}

#pragma mark - coredata stuff

#define iKUHaikuEntityName @"HaikuStore"
#define iKUHaikuEntityIdentifierKey @"identifier"

-(void)addToLocalStore {
    NSManagedObjectContext *context = [self managedObjectContext];
    HaikuStore *haiku = [self localRecord];
    
    if (haiku) {
        return;
    }else {
        haiku = [NSEntityDescription insertNewObjectForEntityForName:iKUHaikuEntityName inManagedObjectContext:context];
        haiku.text = self.text;
        haiku.identifier = self.identifier;
        [self saveContext];
        NSLog(@"added haiku %@", self.identifier);
    }
}

-(void)removeFromLocalStore {
    NSManagedObjectContext *context = [self managedObjectContext];
    HaikuStore *haiku = [self localRecord];
    
    if (haiku) {
        [context deleteObject:haiku];
        [self saveContext];
        NSLog(@"deleted haiku %@", self.identifier);
    }
}


-(HaikuStore*)localRecord {
    NSManagedObjectContext *context = [self managedObjectContext];
    HaikuStore *haiku = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:iKUHaikuEntityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:iKUHaikuEntityIdentifierKey ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", iKUHaikuEntityIdentifierKey, self.identifier];
    
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    if (!matches || matches.count > 1) {
        //        gah? crash & think about what went wrong
        abort();
    }else if (matches.count == 1) {
        haiku = [matches firstObject];
    }
    
    return haiku;
}

-(NSArray*)_debugFetchAllStoredHaiku {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:iKUHaikuEntityName];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:iKUHaikuEntityIdentifierKey ascending:YES]];
    NSError *error = nil;
    
    if (error) {
        NSLog(@"%@", error);

    }
    
    return [context executeFetchRequest:request error:&error];

    
}

-(NSManagedObjectContext*)managedObjectContext {
    IKUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    return appDelegate.managedObjectContext;
}

-(void)saveContext {
    IKUAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate saveContext];
}

@end
