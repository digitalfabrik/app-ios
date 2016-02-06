#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Page.h"
#import "Location.h"
#import "Language.h"


@interface PagesDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Language *selectedLanguage;
@property (strong, nonatomic) Page *parentPage;
@property (weak, nonatomic) UITableView *tableViewToUpdate;

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)prepareTableView:(UITableView *)tableView;

- (BOOL)isLoading;

@end
