#import "IGPagesListVC.h"
#import "IGCustomTableViewCell.h"
#import "IGPageVC.h"
#import "Integreat-Swift.h"


@implementation IGPagesListVC


#pragma mark Lifecycle

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    IGCustomTableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    IGPageVC *pageVC = segue.destinationViewController;
    pageVC.selectedPage = self.pages[indexPath.item];
}


#pragma mark Collection View Data Source

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
    
    Page *page = self.pages[indexPath.item];
    cell.cellTitle.attributedText = page.descriptionText;
    
    return cell;
}


#pragma mark Collection View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Page *page = self.pages[indexPath.item];
    NSAttributedString *text = page.descriptionText;
    CGRect frame = [text boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      context:nil];
    return frame.size.height;
}

@end
