#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Language, Page;
NS_ASSUME_NONNULL_BEGIN


@interface Location : NSManagedObject

+ (nullable instancetype)findLocationWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

@end


NS_ASSUME_NONNULL_END


#import "Location+CoreDataProperties.h"
