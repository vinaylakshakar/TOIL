

#import <UIKit/UIKit.h>

@interface ActiveJobDetailsViewController : UIViewController<UIGestureRecognizerDelegate>
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgJobImageHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
//@property (weak, nonatomic) IBOutlet UIView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UIView *payOptionView;
@property (weak, nonatomic) IBOutlet UILabel *lblJobName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UITextView *txtViewJobDetails;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImagesCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UITextView *txtViewFileDespute;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *profilePicBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *jobImage;
@property (weak, nonatomic) IBOutlet UILabel *lblBidAmount;
//vinay here-
@property (weak, nonatomic) IBOutlet UIButton *disputeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)closeDisputeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) NSMutableDictionary *activejobDetailDict;
@end
