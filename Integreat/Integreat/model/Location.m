#import "Location.h"
#import "Language.h"
#import "Page.h"

@interface Location ()

@property (nonatomic, getter=isLoadingImage) BOOL loadingImage;

@end


@implementation Location

@synthesize loadingImage = _loadingImage;

+ (nullable instancetype)findLocationWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    fetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES] ];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil){
        NSLog(@"Error fetching location for identifier %@: %@", identifier, error);
        return nil;
    }
    return fetchResult.firstObject;
}

+ (void)deleteLocationWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    Location *location = [self findLocationWithIdentifier:identifier inContext:context];
    if (location){
        [context deleteObject:location];
    }
}

- (void)loadIconImageIfNeeded
{
    if (self.iconImageUrl == nil || self.iconImage != nil || self.isLoadingImage){
        return;
    }
    self.loadingImage = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:self.iconImageUrl];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconImage = image;
            [self.managedObjectContext save:nil];
        });
    });
}

@end
