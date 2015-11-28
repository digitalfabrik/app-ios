//
//  IGCityPickerVCCollectionViewController.h
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGApiService.h"


@interface IGCityPickerVCCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IGApiService *apiService;

@end
