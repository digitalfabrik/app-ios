#import "Page.h"
#import "Language.h"
#import "Location.h"


@implementation Page

+ (nullable instancetype)findPageWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Page"];
    fetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES] ];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil){
        NSLog(@"Error fetching page for identifier %@: %@", identifier, error);
        return nil;
    }
    return fetchResult.firstObject;
}

- (void)loadThumbnailImageWithCompletionHandler:(void(^)(UIImage *image))completion
{
    if (self.thumbnailImage != nil){
        completion(self.thumbnailImage);
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:self.thumbnailImageUrl];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage = image;
            completion(self.thumbnailImage);
            [self.managedObjectContext save:nil];
        });
    });
}

@end
