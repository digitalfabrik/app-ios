#import "IGPagesListVC.h"
#import "IGCustomTableViewCell.h"
#import "IGPageVC.h"
#import "Integreat-Swift.h"
#import "IGCityPickerVCCollectionViewController.h"

@interface IGPagesListVC() <NSFetchedResultsControllerDelegate>
    @property (strong,nonatomic) NSArray *pages;
    @property (strong, nonatomic) NSFetchedResultsController *fetchedPages;
@end


@implementation IGPagesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePages];
        
    [self updateNavigationItem];
    
    [self.apiService updatePagesForLocation:self.selectedLocation language:self.selectedLanguage];
    
    self.tableView.contentOffset = CGPointMake(0.0f, CGRectGetHeight(self.pagesSearchBar.bounds));
}

- (void)updateNavigationItem
{
    if (self.parentPage != nil){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.title = self.parentPage.title;
        self.navigationItem.rightBarButtonItem = nil;
    } else if (self.fetchedPages.fetchedObjects.count == 0) {
        self.navigationItem.title = @"Loading...";
    } else {
        self.navigationItem.title = self.selectedLocation.name;
    }
}

- (NSFetchedResultsController *)fetchedPages
{
    if (_fetchedPages != nil){
        return _fetchedPages;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"language == %@ AND location == %@ AND status == %@ AND parentPage = %@",
                              self.selectedLanguage, self.selectedLocation, @"publish", self.parentPage];
    fetchRequest.sortDescriptors = @[
                                     [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:NO]
                                     ];
    _fetchedPages = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                            managedObjectContext:self.apiService.context
                                                              sectionNameKeyPath:nil
                                                                       cacheName:nil];
    _fetchedPages.delegate = self;
    
    NSError *fetchError = nil;
    [_fetchedPages performFetch:&fetchError];
    if (fetchError != nil){
        NSLog(@"Error fetching locations: %@", fetchError);
    }
    
    return _fetchedPages;
}

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section){
        case 0: return self.parentPage;
        case 1: return self.pages[indexPath.item];
        default: return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0: return (self.parentPage != nil) ? 1 : 0;
        case 1: return self.pages.count;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Page *page = [self pageForRowAtIndexPath:indexPath];
    
    NSString *resuseIdentifier = (page.thumbnailImageUrl != nil)
        ? @"cellWithImage" : @"cellWithoutImage";
        
    IGCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier forIndexPath:indexPath];
    cell.cellTitle.attributedText= [page descriptionTextIncludingExcerpt:self.parentPage != nil];
    
    if (page.thumbnailImageUrl != nil) {
        [page loadThumbnailImageWithCompletionHandler:^(UIImage * _Nonnull image) {
            cell.cellImage.image = image;
        }];
    } else {
        cell.cellImage.image = nil;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"segPage"]){
        IGPageVC *pageVC = segue.destinationViewController;
        pageVC.selectedPage = [self pageForRowAtIndexPath:[self.tableView indexPathForCell:sender]];
    }
    else if ([segue.identifier isEqualToString:@"changeSeg"] || [segue.identifier isEqualToString:@"changeSegWithoutAnimation"]){
        UINavigationController *nc = segue.destinationViewController;
        IGCityPickerVCCollectionViewController *vc = (id)nc.topViewController;
        vc.apiService = self.apiService;
    }
}


#pragma mark Data

- (void)updatePages
{
    if (self.pagesSearchBar.text.length > 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@ OR SELF.title contains[c] %@",
                                  self.pagesSearchBar.text, self.pagesSearchBar.text];
        self.pages = [self.fetchedPages.fetchedObjects filteredArrayUsingPredicate:predicate];
    }
    else {
        self.pages = self.fetchedPages.fetchedObjects;
    }
    
    [self.tableView reloadData];
}


#pragma mark Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.pagesSearchBar.text = nil;
    
    CGPoint offset = CGPointMake(0.0f, CGRectGetHeight(self.pagesSearchBar.bounds));
    [self.tableView setContentOffset:offset animated:YES];
    
    [self updatePages];
}


#pragma mark - UISearchDisplayController Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [self updatePages];
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Page *page = [self pageForRowAtIndexPath:indexPath];
    
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


#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.pages.count == 0){
        [self updateNavigationItem];
        [self updatePages];
    }
}

@end
