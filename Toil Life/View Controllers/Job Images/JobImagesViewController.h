//
//  JobImagesViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobImagesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgJobImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) NSMutableArray *jobImagesArray;
@property (weak, nonatomic) UIImage *SelectedImage;
@property NSInteger imageIndex;

@end
