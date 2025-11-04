//
//  EmployerProfileViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 16/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerProfileViewController : UIViewController
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UIImageView *stripeImageView;
@property (weak, nonatomic) IBOutlet UIButton *stripeeditBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating1;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating2;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating3;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating4;
@property (weak, nonatomic) IBOutlet UIImageView *imgRating5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicHeight;
- (IBAction)employerJobHistory:(UIButton *)sender;

@end
