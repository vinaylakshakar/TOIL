//
//  InviteDetailsViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteDetailsViewController : UIViewController
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblJobName;
@property (weak, nonatomic) IBOutlet UITextView *txtViewJobDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblBudget;
@property (weak, nonatomic) IBOutlet UIImageView *imgJobImage;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImageCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgJobImageHeight;
@property (weak, nonatomic) NSMutableDictionary* inviteJobDetailDict;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;

@end
