#import "IGPagesListVC.h"
#import "IGCustomTableViewCell.h"
#import "IGPageVC.h"


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
                         weakSelf.pages = pages;
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
    
    cell.cellTitle.text=[page title];
    
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

@end
