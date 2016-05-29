#import <UIKit/UIKit.h>
#import "Location.h"
NS_ASSUME_NONNULL_BEGIN


@interface Location (CoreDataProperties)

@property (nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *resourceName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) UIImage* iconImage;
@property (nullable, nonatomic, retain) NSURL *iconImageUrl;

@property (nullable, nonatomic, retain) NSSet<Language *> *languages;
@property (nullable, nonatomic, retain) NSSet<Page *> *pages;

@end


NS_ASSUME_NONNULL_END
