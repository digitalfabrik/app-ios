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

@end
