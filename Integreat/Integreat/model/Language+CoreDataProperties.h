#import "Language.h"
#import <UIKit/UIKit.h>


@interface Language (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *resourceName;
@property (nonatomic) NSUInteger identifier;
@property (nullable, nonatomic, retain) NSURL *iconImageUrl;
@property (nullable, nonatomic, retain) UIImage *iconImage;
@property (nullable, nonatomic, retain) NSString *nativeName;

@property (nullable, nonatomic, retain) Location *locations;
@property (nullable, nonatomic, retain) Page *pages;

@end
