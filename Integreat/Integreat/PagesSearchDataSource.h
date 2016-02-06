#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Page.h"


@interface PagesSearchDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateSearchedPagesWithQuery:(NSString *)query;

- (void)prepareTableView:(UITableView *)tableView;

@end
