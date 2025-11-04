//
//  EmployerPersonalInformationViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerPersonalInformationViewController : UIViewController
{
    NSMutableArray *searchArr;
    MKCoordinateRegion searchedRegion;
    IBOutlet UIScrollView *mainScl;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldRecoveryEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldBussinessName;

@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITableView *addressTblView;

@property (weak, nonatomic) IBOutlet UIPickerView *distancePickerView;

@end
