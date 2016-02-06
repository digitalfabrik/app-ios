#import "PagesDataSource.h"
#import "IGCustomTableViewCell.h"
#import "Integreat-Swift.h"

@interface PagesDataSource () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedPages;

@end


@implementation PagesDataSource

- (void)prepareTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"PageCell" bundle:nil] forCellReuseIdentifier:@"PageCell"];
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
                                                        managedObjectContext:self.context
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

- (Page *)pageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0: return self.parentPage;
        case 1: return self.fetchedPages.fetchedObjects[indexPath.item];
        default: return nil;
    }
}


#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0: return (self.parentPage != nil) ? 1 : 0;
        case 1: return self.fetchedPages.fetchedObjects.count;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Page *page = [self pageForRowAtIndexPath:indexPath];
    
    NSString *resuseIdentifier = @"PageCell";
    
    IGCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier forIndexPath:indexPath];
    cell.cellTitle.attributedText = [page descriptionTextIncludingExcerpt:self.parentPage != nil];
    
    if (page.thumbnailImageUrl != nil) {
        cell.tag = page.thumbnailImageUrl.hash;
        [page loadThumbnailImageWithCompletionHandler:^(UIImage * _Nonnull image) {
            if (cell.tag == page.thumbnailImageUrl.hash){
                cell.cellImage.image = image;
            }
        }];
    } else {
        cell.cellImage.image = nil;
    }
    
    return cell;
}


#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableViewToUpdate beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type){
        case NSFetchedResultsChangeDelete:
            indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:1];
            [self.tableViewToUpdate deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeInsert:
            newIndexPath = [NSIndexPath indexPathForItem:newIndexPath.item inSection:1];
            [self.tableViewToUpdate insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:1];
            newIndexPath = [NSIndexPath indexPathForItem:newIndexPath.item inSection:1];
            [self.tableViewToUpdate moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:1];
            [self.tableViewToUpdate reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableViewToUpdate endUpdates];
}

- (BOOL)isLoading
{
    return self.fetchedPages.fetchedObjects.count == 0;
}

@end
