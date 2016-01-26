//
//  IGLanguagePickerVC.h
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGApiService.h"
#import "Location.h"

extern NSString *IGLanguagePickedNotification;

@interface IGLanguagePickerVC : UICollectionViewController <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IGApiService *apiService;
@property (nonatomic) Location* selectedLocation;
@end
