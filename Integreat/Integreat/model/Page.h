#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
@class Language, Location;
NS_ASSUME_NONNULL_BEGIN


@interface Page : NSManagedObject

+ (nullable instancetype)findPageWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context;

- (void)loadThumbnailImageWithCompletionHandler:(void(^)(UIImage *image))completion;

@end


NS_ASSUME_NONNULL_END

#import "Page+CoreDataProperties.h"
