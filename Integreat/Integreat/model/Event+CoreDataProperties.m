//
//  Event+CoreDataProperties.m
//  Integreat
//
//  Created by Hazem Safetli on 29/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

@dynamic identifier;
@dynamic content;
@dynamic address;
@dynamic startDate;
@dynamic startTime;
@dynamic language;
@dynamic location;
@dynamic lastModified;
@end
