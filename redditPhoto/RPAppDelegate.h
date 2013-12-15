//
//  RPAppDelegate.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSubSelectViewController.h"

@interface RPAppDelegate : UIResponder <UIApplicationDelegate>{

}
    
    
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (NSArray *) fetchNames;
@end
