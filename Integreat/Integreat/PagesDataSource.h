#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Page.h"
#import "Location.h"
#import "Language.h"
@protocol PagesDataSourceDelegate;


@interface PagesDataSource : NSObject <UITableViewDataSource>

@property (weak, nonatomic) id<PagesDataSourceDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) Language *selectedLanguage;
@property (strong, nonatomic) Page *parentPage;

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)prepareTableView:(UITableView *)tableView;

- (BOOL)isLoading;

@end


@protocol PagesDataSourceDelegate <NSObject>

- (void)pagesDataSourceDidChange:(PagesDataSource *)pagesDataSource;
- (UITableView *)tableViewToUpdateForPagesDataSource:(PagesDataSource *)pagesDataSource;

@end