#import "IGPagesListVC.h"
#import "IGPageVC.h"
#import "Integreat-Swift.h"
#import "IGCityPickerVCCollectionViewController.h"
#import "PagesDataSource.h"
#import "PagesSearchDataSource.h"

@interface IGPagesListVC() <UISearchDisplayDelegate>

@property (strong, nonatomic) PagesDataSource *pagesDataSource;
@property (strong, nonatomic) PagesSearchDataSource *pagesSearchDataSource;

@end


@implementation IGPagesListVC

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateNavigationItem];
    
    [self.apiService updatePagesForLocation:self.selectedLocation language:self.selectedLanguage];
    
    self.pagesDataSource = [[PagesDataSource alloc] init];
    self.pagesDataSource.parentPage = self.parentPage;
    self.pagesDataSource.context = self.apiService.context;
    self.pagesDataSource.selectedLanguage = self.selectedLanguage;
    self.pagesDataSource.selectedLocation = self.selectedLocation;
    self.pagesDataSource.tableViewToUpdate = self.tableView;
    [self.pagesDataSource prepareTableView:self.tableView];
    self.tableView.dataSource = self.pagesDataSource;
    
    if (self.parentPage != nil){
        self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
}

- (void)updateNavigationItem
{
    if (self.parentPage != nil){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = self.parentPage.title;
        self.navigationItem.rightBarButtonItem = nil;
    } else if (self.pagesDataSource.isLoading) {
        self.navigationItem.title = @"Loading...";
    } else {
        self.navigationItem.title = self.selectedLocation.name;
    }
}


#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"segPage"]){
        IGPageVC *pageVC = segue.destinationViewController;
        pageVC.selectedPage = [self pageForCell:sender];
    }
    else if ([segue.identifier isEqualToString:@"changeSeg"] || [segue.identifier isEqualToString:@"changeSegWithoutAnimation"]){
        UINavigationController *nc = segue.destinationViewController;
        IGCityPickerVCCollectionViewController *vc = (id)nc.topViewController;
        vc.apiService = self.apiService;
    }
}


#pragma mark Table View Delegate

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    if (tableView == self.tableView){
        return [self.pagesDataSource pageForRowAtIndexPath:indexPath];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.pagesDataSource pageForRowAtIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (Page *)pageForCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath != nil){
        return [self.pagesDataSource pageForRowAtIndexPath:indexPath];
    } else {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
        return [self.pagesDataSource pageForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Page *page = [self pageForRowAtIndexPath:indexPath inTableView:tableView];
    
    if (page != self.parentPage && page.publishedChildPages.count > 0){
        IGPagesListVC *pagesListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PagesListVC"];
        pagesListVC.apiService = self.apiService;
        pagesListVC.selectedLocation = self.selectedLocation;
        pagesListVC.selectedLanguage = self.selectedLanguage;
        pagesListVC.parentPage = page;
        [self.navigationController pushViewController:pagesListVC animated:true];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"segPage" sender:cell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.parentPage == nil){
        return 60.0f;
    } else {
        return 80.0f;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Page *page = [self pageForRowAtIndexPath:indexPath];
//    NSAttributedString *text = [page descriptionTextIncludingExcerpt:self.parentPage != nil];
//    
//    CGRect frame = [text boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
//                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                      context:nil];
//    
//    return MAX(frame.size.height, 80.0f);
//}


#pragma mark <UISearchDisplayDelegate>

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    self.pagesSearchDataSource = [[PagesSearchDataSource alloc] init];
    self.pagesSearchDataSource.context = self.apiService.context;
    [self.pagesSearchDataSource prepareTableView:tableView];
    tableView.dataSource = self.pagesSearchDataSource;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.pagesSearchDataSource updateSearchedPagesWithQuery:searchString];
    return true;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
    tableView.dataSource = nil;
    self.pagesSearchDataSource = nil;
}

@end
