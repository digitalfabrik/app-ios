#import "Language.h"
#import <UIKit/UIKit.h>


@interface Language (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *resourceName;
@property (nullable, nonatomic, retain) NSURL *iconImageUrl;
@property (nullable, nonatomic, retain) UIImage *iconImage;
@property (nullable, nonatomic, retain) NSString *nativeName;

@property (nullable, nonatomic, retain) NSSet<Location *> *locations;
@property (nullable, nonatomic, retain) NSSet<Page *> *pages;

@end
