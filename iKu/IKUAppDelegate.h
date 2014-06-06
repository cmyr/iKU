//
//  IKUAppDelegate.h
//  iKu
//
//  Created by Colin Rofls on 2014-05-21.
//  Copyright (c) 2014 Brisk Synergies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
