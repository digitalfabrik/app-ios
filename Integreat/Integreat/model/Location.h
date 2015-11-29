#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
@class Language, Page;
NS_ASSUME_NONNULL_BEGIN


typedef void(^GetLocationImageCompletionBlock)(UIImage *image);


@interface Location : NSManagedObject

+ (nullable instancetype)findLocationWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

- (void)loadIconImageIfNeeded;

@end


NS_ASSUME_NONNULL_END


#import "Location+CoreDataProperties.h"
