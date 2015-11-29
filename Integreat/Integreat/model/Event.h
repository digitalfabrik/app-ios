//
//  Event.h
//  Integreat
//
//  Created by Hazem Safetli on 29/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Language, Location;

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSManagedObject

+ (nullable instancetype)findEventWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;
// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Event+CoreDataProperties.h"
