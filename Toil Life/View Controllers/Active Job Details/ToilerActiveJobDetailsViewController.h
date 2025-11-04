

#import <UIKit/UIKit.h>

@interface ToilerActiveJobDetailsViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgJobImageHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
//@property (weak, nonatomic) IBOutlet UIView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
//vinay here-
@property (weak, nonatomic) IBOutlet UIButton *disputeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblJobName;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UITextView *txtViewJobDetails;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImagesCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewFileDespute;

@property (weak, nonatomic) IBOutlet UIImageView *jobImage;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) NSMutableDictionary *activejobDetailDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewHeight;
@end

