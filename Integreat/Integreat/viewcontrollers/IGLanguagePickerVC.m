//
//  IGLanguagePickerVC.m
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import "IGLanguagePickerVC.h"
#import "IGCustomCollectionViewCell.h"
#import "IGPagesListVC.h"

NSString *IGLanguagePickedNotification = @"IGLanguagePickedNotification";


@interface IGLanguagePickerVC () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedLanguages;
@property (strong, nonatomic) NSArray *changes;

@end


@implementation IGLanguagePickerVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Language"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%@ IN locations", self.selectedLocation];
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"nativeName" ascending:YES]
    ];
    self.fetchedLanguages = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                managedObjectContext:self.apiService.context
                                                                  sectionNameKeyPath:nil
                                                                           cacheName:nil];
    self.fetchedLanguages.delegate = self;
    
    NSError *fetchError = nil;
    [self.fetchedLanguages performFetch:&fetchError];
    if (fetchError != nil){
        NSLog(@"Error fetching locations: %@", fetchError);
    }
    
    [self updateNavigationItem];
    
    [self.apiService upateLanguagesForLocation:self.selectedLocation];
}

- (void)updateNavigationItem
{
    if (self.fetchedLanguages.fetchedObjects.count == 0){
        self.navigationItem.title = @"Loading...";
    } else {
        self.navigationItem.title = @"Language";
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedLanguages.sections.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedLanguages.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IGCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Language *language = [self.fetchedLanguages objectAtIndexPath:indexPath];
    [language loadIconImageIfNeeded];
    
    cell.cellTitle.text = language.nativeName;
    cell.cellImage.image = language.iconImage;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat dimens = collectionView.bounds.size.width * 0.4;
    return CGSizeMake(dimens, dimens);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Language *language = [self.fetchedLanguages objectAtIndexPath:indexPath];
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedLocation.identifier forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] setObject:language.identifier forKey:@"language"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IGLanguagePickedNotification object:nil];
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
    
    [self updateNavigationItem];
}

@end
