//
//  IGCityPickerVCCollectionViewController.m
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "IGCityPickerVCCollectionViewController.h"
#import "SlimConnectionManager.h"
#import "IGCustomCollectionViewCell.h"
#import "IGLanguagePickerVC.h"


@interface IGCityPickerVCCollectionViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedLocations;
@property (strong, nonatomic) NSArray *changes;

@end


@implementation IGCityPickerVCCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]
    ];
    self.fetchedLocations = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                managedObjectContext:self.apiService.context
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:nil];
    self.fetchedLocations.delegate = self;
    
    NSError *fetchError = nil;
    [self.fetchedLocations performFetch:&fetchError];
    if (fetchError != nil){
        NSLog(@"Error fetching locations: %@", fetchError);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.apiService updateLocations];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"langSeg"])
    {
        // Get reference to the destination view controller
        IGLanguagePickerVC *vc = [segue destinationViewController];
        IGCustomCollectionViewCell* selectedCell=(IGCustomCollectionViewCell*)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:selectedCell];
        vc.selectedLocation= [self.fetchedLocations objectAtIndexPath:indexPath];
        vc.apiService = self.apiService;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedLocations.sections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedLocations.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IGCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Location *location = [self.fetchedLocations objectAtIndexPath:indexPath];
    
    cell.cellTitle.text= location.name;
    
    [location loadIconImageIfNeeded];
    cell.cellImage.image = location.iconImage;
    
    cell.accessibilityIdentifier = location.name;
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dimens = collectionView.bounds.size.width * 0.4;
    return CGSizeMake(dimens, dimens);
}


#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.changes = @[];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.collectionView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    void(^change)() = ^{
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];
                break;
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
                break;
            case NSFetchedResultsChangeMove:
                [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    };
    self.changes = [self.changes arrayByAddingObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView performBatchUpdates:^{
        for (void(^change)() in self.changes){
            change();
        }
    } completion:nil];
    self.changes = nil;
}

@end
