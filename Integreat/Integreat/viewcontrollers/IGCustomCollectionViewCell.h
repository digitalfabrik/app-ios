//
//  IGCustomCollectionViewCell.h
//  Integreat
//
//  Created by Hazem Safetli on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGCustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;

@end
