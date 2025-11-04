//
//  CardCell.h
//  Toil Life
//
//  Created by Silstone on 14/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *cardNumberLbl;
@property(nonatomic,strong)IBOutlet UIImageView *cardImage;
@property(nonatomic,strong)IBOutlet UIButton *cardBtn;
@end
