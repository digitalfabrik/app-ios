#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Location, Page;

NS_ASSUME_NONNULL_BEGIN


@interface Language : NSManagedObject

+ (nullable instancetype)findLanguageWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

@end


NS_ASSUME_NONNULL_END

#import "Language+CoreDataProperties.h"
