

#import <UIKit/UIKit.h>

@interface BidsJobDetailsViewController : UIViewController
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *txtBidAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UITextView *txtViewCurrentBidDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblBudgetAmount;
//@property (weak, nonatomic) IBOutlet UIView *bidAmountView;
@property (weak, nonatomic) IBOutlet UIScrollView *bidAmountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgJobImageHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *topBidCollectionView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UICollectionView *jobImagesCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bidBtnView;
@property (weak, nonatomic) IBOutlet UIView *currentBidView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSMutableDictionary *jobBidDetailDict;
@property (weak, nonatomic) IBOutlet UIImageView *jobImage;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *noBidLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeight;

@end
