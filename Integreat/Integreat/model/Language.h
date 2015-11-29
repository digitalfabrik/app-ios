#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
@class Location, Page;

NS_ASSUME_NONNULL_BEGIN

typedef void(^GetLanguageImageCompletionBlock)(UIImage *image);


@interface Language : NSManagedObject

+ (nullable instancetype)findLanguageWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

- (void)loadIconImageIfNeeded;

@end


NS_ASSUME_NONNULL_END

#import "Language+CoreDataProperties.h"
