

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ToilerEditProfileDetailsViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *searchArr;
    MKCoordinateRegion searchedRegion;
    NSString *latitute;
    NSString *longitude;
    IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldRecoveryEmail;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAbout;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITableView *addressTblView;

@property (weak, nonatomic) IBOutlet UIPickerView *distancePickerView;
@property (strong, nonatomic) NSMutableDictionary *toilerProfileDict;


@end
