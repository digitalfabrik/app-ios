//
//  IGCustomTableViewCell.h
//  Integreat
//
//  Created by Chris Schneider on 28/11/15.
//  Copyright © 2015 Integreat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGCustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;

@end
