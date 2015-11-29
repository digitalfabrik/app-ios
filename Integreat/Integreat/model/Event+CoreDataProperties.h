//
//  Event+CoreDataProperties.h
//  Integreat
//
//  Created by Hazem Safetli on 29/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *startDate;
@property (nullable, nonatomic, retain) NSString *startTime;
@property (nullable, nonatomic, retain) Language *language;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSDate *lastModified;


@end

NS_ASSUME_NONNULL_END
