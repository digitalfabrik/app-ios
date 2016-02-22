#import "PagesSearchDataSource.h"
#import "IGCustomTableViewCell.h"
#import "Integreat-Swift.h"

@interface PagesSearchDataSource ()

@property (strong, nonatomic) NSArray *searchedPages;

@end


@implementation PagesSearchDataSource

- (void)prepareTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"PageCell" bundle:nil] forCellReuseIdentifier:@"PageCell"];
}

- (void)updateSearchedPagesWithQuery:(NSString *)query
{
    if (query.length == 0){
        self.searchedPages = nil;
        return;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Page"];
    fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[
       [NSPredicate predicateWithFormat:@"language == %@ AND location == %@", self.selectedLanguage, self.selectedLocation],
       [NSPredicate predicateWithFormat:@"status == %@", @"publish"],
       [NSPredicate predicateWithFormat:@"SELF.content contains[c] %@ OR SELF.title contains[c] %@", query, query]
    ]];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES] ];
    
    NSError *error = nil;
    self.searchedPages = [self.context executeFetchRequest:fetchRequest error:&error];
    if (error != nil){
        NSLog(@"Error fetching pages: %@", error);
    }
}

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.searchedPages[indexPath.item];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedPages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Page *page = [self pageForRowAtIndexPath:indexPath];
    
    NSString *resuseIdentifier = @"PageCell";
    
    IGCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier forIndexPath:indexPath];
    cell.cellTitle.attributedText= [page descriptionTextIncludingExcerpt:true];
    
    if (page.thumbnailImageUrl != nil) {
        [page loadThumbnailImageWithCompletionHandler:^(UIImage * _Nonnull image) {
            cell.cellImage.image = image;
        }];
    } else {
        cell.cellImage.image = nil;
    }
    
    return cell;
}

@end
