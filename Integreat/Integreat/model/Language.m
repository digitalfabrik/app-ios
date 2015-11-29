#import "Language.h"
#import "Location.h"
#import "Page.h"


@implementation Language

+ (nullable instancetype)findLanguageWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Language"];
    fetchRequest.sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES] ];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil){
        NSLog(@"Error fetching language for identifier %@: %@", identifier, error);

        return nil;
    }
    return fetchResult.firstObject;
}

- (void)loadIconImageIfNeeded
{
    if (self.iconImage != nil){
        return;
    }
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
