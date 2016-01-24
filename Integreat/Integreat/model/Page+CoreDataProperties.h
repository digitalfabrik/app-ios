#import "Page.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface Page (CoreDataProperties)

@property (nonatomic, retain) NSNumber *identifier;
@property (nullable, nonatomic, retain) NSString *excerpt;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *lastModified;
@property (nullable, nonatomic, retain) NSString *order;
@property (nullable, nonatomic, retain) NSURL *thumbnailImageUrl;
@property (nullable, nonatomic, retain) UIImage *thumbnailImage;

@property (nullable, nonatomic, retain) Language *language;
@property (nullable, nonatomic, retain) Location *location;

@property (nullable, nonatomic, retain) Page *parentPage;
@property (nullable, nonatomic, retain) NSSet<Page *> *childPages;

@end


@interface Page (CoreDataGeneratedAccessors)

- (void)addChildPagesObject:(Page *)value;
- (void)removeChildPagesObject:(Page *)value;
- (void)addChildPages:(NSSet<Page *> *)values;
- (void)removeChildPages:(NSSet<Page *> *)values;

@end


NS_ASSUME_NONNULL_END
