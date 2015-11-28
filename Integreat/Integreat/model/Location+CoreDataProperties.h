#import "Location.h"
NS_ASSUME_NONNULL_BEGIN


@interface Location (CoreDataProperties)

@property (nonatomic) NSUInteger identifier;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *resourceName;
@property (nullable, nonatomic, retain) NSString *color;
@property (nullable, nonatomic, retain) id coverImage;
@property (nullable, nonatomic, retain) id coverImageUrl;
@property (nullable, nonatomic, retain) id iconImage;
@property (nullable, nonatomic, retain) id iconImageUrl;

@property (nullable, nonatomic, retain) Language *languages;
@property (nullable, nonatomic, retain) Page *pages;

@end


NS_ASSUME_NONNULL_END
