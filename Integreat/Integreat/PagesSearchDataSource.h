#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Page.h"


@interface PagesSearchDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Language *selectedLanguage;

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateSearchedPagesWithQuery:(NSString *)query;

- (void)prepareTableView:(UITableView *)tableView;

@end
