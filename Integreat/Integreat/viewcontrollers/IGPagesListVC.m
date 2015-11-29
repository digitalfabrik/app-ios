#import "IGPagesListVC.h"
#import "IGCustomTableViewCell.h"
#import "IGPageVC.h"
#import "Integreat-Swift.h"

@interface IGPagesListVC() <NSFetchedResultsControllerDelegate>
    @property (strong,nonatomic) NSArray *pages;
    @property (strong, nonatomic) NSFetchedResultsController *fetchedPages;
@end


@implementation IGPagesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"language == %@ AND location == %@",
                              self.selectedLanguage, self.selectedLocation];
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:NO]
    ];
    self.fetchedPages = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                            managedObjectContext:self.apiService.context
                                                              sectionNameKeyPath:nil
                                                                       cacheName:nil];
    self.fetchedPages.delegate = self;
    
    NSError *fetchError = nil;
    [self.fetchedPages performFetch:&fetchError];
    if (fetchError != nil){
        NSLog(@"Error fetching locations: %@", fetchError);
    }
    
    [self updatePages];
    
    self.tableView.contentOffset = CGPointMake(0.0f, 45.0f);
    
    self.navigationItem.title = self.selectedLocation.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.apiService updatePagesForLocation:self.selectedLocation language:self.selectedLanguage];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Page *page = self.pages[indexPath.item];
    
    NSString *resuseIdentifier = (page.thumbnailImageUrl != nil)
        ? @"cellWitImage" : @"cellWithoutImage";
    
    IGCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithoutImage" forIndexPath:indexPath];
    cell.cellTitle.attributedText=[page descriptionText];
    cell.cellImage.image = page.thumbnailImage;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    IGCustomTableViewCell *cell = sender;
    IGPageVC *pageVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    pageVC.selectedPage = self.pages[indexPath.item];
}


#pragma mark Data

- (void)updatePages
{
    if (self.pagesSearchBar.text.length > 0){
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@", self.pagesSearchBar.text];
        
        self.pages=[self.fetchedPages.fetchedObjects filteredArrayUsingPredicate:predicate];
    }
    else {
        self.pages = self.fetchedPages.fetchedObjects;
    }
    
    [self.tableView reloadData];
}


#pragma mark Search

- (IBAction)searchPagesContent:(id)sender {
    [self.pagesSearchBar becomeFirstResponder];
    self.tableView.contentOffset = CGPointMake(0.0f, -20.0f);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}


#pragma mark - UISearchDisplayController Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [self updatePages];
}

#pragma mark Table View Delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Page *page = self.pages[indexPath.item];
//    NSAttributedString *text = page.descriptionText;
//    CGRect frame = [text boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
//                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                      context:nil];
//    return frame.size.height;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Page *page = self.pages[indexPath.item];
    [page loadThumbnailImageWithCompletionHandler:^(UIImage * _Nonnull image) {
        ((IGCustomTableViewCell *)cell).imageView.image = image;
    }];
}


#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updatePages];
}

@end
