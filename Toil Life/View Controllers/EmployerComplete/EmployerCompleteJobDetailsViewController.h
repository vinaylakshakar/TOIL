

#import <UIKit/UIKit.h>

@interface EmployerCompleteJobDetailsViewController : UIViewController
{
     IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgJobImageHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgError;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotReceived;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblJobName;
@property (weak, nonatomic) IBOutlet UIScrollView *rateView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewJobDetails;
//@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *rateView;
@property (weak, nonatomic) IBOutlet UICollectionView *jobImagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (weak, nonatomic) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirstStar;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecondStar;
@property (weak, nonatomic) IBOutlet UIImageView *imgThirdStar;
@property (weak, nonatomic) IBOutlet UIImageView *imgFourthStar;
@property (weak, nonatomic) IBOutlet UIImageView *imgFifthStar;
//@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) NSMutableDictionary *completedJobDict;
@property (weak, nonatomic) IBOutlet UIImageView *jobImage;
//@property (weak, nonatomic) IBOutlet UIScrollView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UIView *fileDesputeView;
@property (weak, nonatomic) IBOutlet UITextView *txtViewFileDespute;
@property (weak, nonatomic) IBOutlet UIButton *makePaymentBtn;
//vinay here-
@property (weak, nonatomic) IBOutlet UIButton *disputeBtn;

@end
