//
//  EmployerPersonalInformationViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EmployerPersonalInformationViewController.h"

@interface EmployerPersonalInformationViewController ()
{
    NSMutableArray *arrDistance;
}
@end

@implementation EmployerPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // _btnNext.enabled = NO;
    
    if(IS_iPHONE_5){
        [_txtViewAddress setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 650);
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    arrDistance = [[NSMutableArray alloc] initWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50", nil];
    _addressTblView.hidden = YES;
    
    
}
#pragma mark - Picker View Data Source and Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return arrDistance.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%@ KM",arrDistance[row]];
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
}

#pragma mark - textfield Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if (range.length==0) {
        if ([text isEqualToString:@"\n"]) {
            _addressTblView.hidden = YES;
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
    
}

#pragma mark - Button action

- (IBAction)actionNextBtn:(UIButton *)sender {
    if([_txtViewAddress.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please Enter Address."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if ([_txtFieldFirstName.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter first name."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([_txtFieldLastName.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter last name."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([_txtFieldRecoveryEmail.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter recovery email."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
//    else if ([_txtFieldBussinessName.text isEqualToString:@""]){
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
//                                                                       message:@"Please Enter Bussiness Name."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    else{
        LoginProcess *sharedManager = [LoginProcess sharedManager];
        bool emailValid = [sharedManager emailValidate:_txtFieldRecoveryEmail];
        if(emailValid){
            
            //UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EmployerProfilePictureViewController *EmployerProfilePictureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmployerProfilePictureVC"];
            EmployerProfilePictureVC.employerInfoDict = [self getEmployerInfo];
            [self.navigationController pushViewController:EmployerProfilePictureVC animated:YES];
        }
        else{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                           message:@"Please enter correct recovery email address."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

-(NSMutableDictionary*)getEmployerInfo
{
    NSString *radius = [arrDistance objectAtIndex:[self.distancePickerView selectedRowInComponent:0]];
    
    NSMutableDictionary *employerInfo = [[NSMutableDictionary alloc]init];
    [employerInfo setObject:self.txtFieldFirstName.text forKey:@"FirstName"];
    [employerInfo setObject:self.txtFieldLastName.text forKey:@"LastName"];
    [employerInfo setObject:self.txtFieldRecoveryEmail.text forKey:@"Email"];
    [employerInfo setObject:self.txtViewAddress.text forKey:@"UserAddress"];
    [employerInfo setObject:radius forKey:@"SearchJobRadius"];
    [employerInfo setObject:@"Employer" forKey:@"RoleName"];
    [employerInfo setObject:@"0" forKey:@"id"];
    [employerInfo setObject:[USERDEFAULTS valueForKey:MobileNo] forKey:@"MobileNo"];
    
    if ([self.txtFieldBussinessName.text isEqualToString:@""]) {
        [employerInfo setObject:@"" forKey:@"BusinessName"];
    } else {
        [employerInfo setObject:self.txtFieldBussinessName.text forKey:@"BusinessName"];
    }
    
    
    return employerInfo;
    
}

- (IBAction)actionBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom search Method

-(void)SearchText:(NSString *)text
{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    NSString *typedData = text;
    if([typedData isEqualToString:@""])
    {}
    else{
        
        [searchRequest setNaturalLanguageQuery:typedData];
        [searchRequest setRegion:searchedRegion];
        
        
        // Create the local search to perform the search
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
        
        //[ProgressHUD show];
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            if (!error) {
                
                //[ProgressHUD dismiss];
                searchArr = [NSMutableArray arrayWithArray:[response mapItems]];
                
                if(searchArr.count>=1)
                {
                    _addressTblView.hidden  = false;
                    _addressTblView.delegate = self;
                    _addressTblView.dataSource  =self;
                    [_addressTblView reloadData];
                }
                else{
                    _addressTblView.hidden  = true;
                }
                
                
                
                
            } else {
                NSLog(@"Search Request Error: %@", [error localizedDescription]);
            }
        }];
    }
    
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableCell" forIndexPath:indexPath];
    //cell.btnLocation.tag = indexPath.row;
    MKMapItem *mapItem = [searchArr objectAtIndex:indexPath.row];
    cell.lblLocation.text = [NSString stringWithFormat:@"%@",[[mapItem placemark] title]];
    //[cell.btnLocation addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mapItem = [searchArr objectAtIndex:indexPath.row];
    _txtViewAddress.text = [NSString stringWithFormat:@"%@",[[mapItem placemark] title]];
    _addressTblView.hidden = YES;
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == _txtViewAddress)
    {
        if([_txtViewAddress.text isEqualToString:@"Add Location"]){
            
            _txtViewAddress.text = @"";
            _txtViewAddress.textColor = [UIColor darkGrayColor];
            
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == _txtViewAddress)
    {
        if([_txtViewAddress.text isEqualToString:@""]){
            
            _txtViewAddress.text = @"Add Location";
            _txtViewAddress.textColor = Grey_COLOR;
            _addressTblView.hidden = YES;
        }
    }
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView == _txtViewAddress)
    {
        if(_txtViewAddress.text.length == 0)
        {
            _addressTblView.hidden = true;
            _txtViewAddress.textColor = Grey_COLOR;
            _txtViewAddress.text = @"Add Location";
            [_txtViewAddress resignFirstResponder];
        }
        else{
            [self SearchText:textView.text];
        }
    }
}


@end
