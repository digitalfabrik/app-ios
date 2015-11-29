#import "IGPagesListVC.h"
#import "IGCustomTableViewCell.h"
#import "IGPageVC.h"
#import "Integreat-Swift.h"

@interface IGPagesListVC()
    @property (strong,nonatomic) NSMutableArray *filteredSearchPagesArray;
@end

@implementation IGPagesListVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pages = @[];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    typeof(self) weakSelf = self;
    [self.apiService fetchPagesForLocation:self.selectedLocation
                                  language:self.selectedLanguage
                     withCompletionHandler:^(NSArray<Page *> * _Nullable pages, NSError * _Nullable error) {
                         NSMutableArray *filteredPages = [NSMutableArray array];
                         for (Page *page in pages) {
                             if (page.parentPage == nil) {
                                 [filteredPages addObject:page];
                             }
                         }
                         weakSelf.filteredSearchPagesArray = [NSMutableArray arrayWithCapacity:[filteredPages count]];
                         weakSelf.pages = filteredPages;
                         [weakSelf.tableView reloadData];
                     }];
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
    IGCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithoutImage" forIndexPath:indexPath];
    
    Page *page = self.pages[indexPath.row];
    
    cell.cellTitle.attributedText=[page descriptionText];
    
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

#pragma mark Search

- (IBAction)searchPagesContent:(id)sender {
    self.pagesSearchBar.hidden=NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.pagesSearchBar.hidden=YES;
}


#pragma mark - UISearchDisplayController Delegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{

    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@",searchText];
    
    self.pages=[self.pages filteredArrayUsingPredicate:predicate];

    [self.tableView reloadData];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredSearchPagesArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name like[cd] %@",searchText];
   self.filteredSearchPagesArray = [NSMutableArray arrayWithArray:[self.pages filteredArrayUsingPredicate:predicate]];
}

#pragma mark Collection View Delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Page *page = self.pages[indexPath.item];
//    NSAttributedString *text = page.descriptionText;
//    CGRect frame = [text boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
//                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
//                                      context:nil];
//    return frame.size.height;
//}


@end
