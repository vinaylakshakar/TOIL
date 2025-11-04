

#import "ToilerEditProfileDetailsViewController.h"

@interface ToilerEditProfileDetailsViewController ()
{
    NSArray *arrDistance;
}

@end

@implementation ToilerEditProfileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_iPHONE_5){
        [_txtViewAddress setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        [_txtViewAbout setFont:[UIFont fontWithName:@"OpenSans" size:13]];
         mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 650);
    }
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    arrDistance = [[NSArray alloc] initWithObjects:@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50", nil];
    _addressTblView.hidden = YES;
    
    [self setLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self geoCodeUsingAddress:_txtViewAddress.text];
}

-(void)setLayout
{
    NSLog(@"%@",self.toilerProfileDict);
    self.txtFieldFirstName.text =[self.toilerProfileDict valueForKey:@"FirstName"];
    self.txtFieldLastName.text =[self.toilerProfileDict valueForKey:@"LastName"];
    self.txtFieldRecoveryEmail.text =[self.toilerProfileDict valueForKey:@"Email"];
    self.txtViewAbout.text =[self.toilerProfileDict valueForKey:@"AboutMe"];
    self.txtViewAddress.text =[self.toilerProfileDict valueForKey:@"UserAddress"];
    NSString *radiusStr = [NSString stringWithFormat:@"%@",[self.toilerProfileDict valueForKey:@"SearchJobRadius"]];
    NSUInteger fooIndex = [arrDistance indexOfObject:radiusStr];
    
    if(NSNotFound == fooIndex) {
        NSLog(@"not found");
    }else
    {
        [self.distancePickerView selectRow:fooIndex inComponent:0 animated:YES];
    }
    
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

#pragma mark - Button action

- (IBAction)actionNextBtn:(UIButton *)sender {
    if([_txtViewAddress.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter address."
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
    else if ([_txtViewAbout.text isEqualToString:@""]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please enter about me."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        LoginProcess *sharedManager = [LoginProcess sharedManager];
        bool emailValid = [sharedManager emailValidate:_txtFieldRecoveryEmail];
        if(emailValid){
            
            //[self.navigationController popViewControllerAnimated:YES];
            [self EditToilerProfile];
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

#pragma mark - Api Method


- (void)EditToilerProfile
{
    NSLog(@"mobile no. %@",[USERDEFAULTS valueForKey:MobileNo]);
    //[kAppDelegate showProgressHUD];
    NSString *radius = [arrDistance objectAtIndex:[self.distancePickerView selectedRowInComponent:0]];
    NSMutableDictionary *editDict = [[NSMutableDictionary alloc]init];
    [editDict setObject:@"Toiler" forKey:@"RoleName"];
    [editDict setObject:self.txtFieldFirstName.text forKey:@"FirstName"];
    [editDict setObject:self.txtFieldLastName.text forKey:@"LastName"];
    [editDict setObject:self.txtFieldRecoveryEmail.text forKey:@"Email"];
    [editDict setObject:self.txtViewAbout.text forKey:@"AboutMe"];
    [editDict setObject:[USERDEFAULTS valueForKey:MobileNo] forKey:@"MobileNo"];
    [editDict setObject:@"" forKey:@"BusinessName"];
    [editDict setObject:self.txtViewAddress.text forKey:@"UserAddress"];
    [editDict setObject:latitute forKey:@"AddressLatitude"];
    [editDict setObject:longitude forKey:@"AddressLongitude"];
    [editDict setObject:radius forKey:@"SearchJobRadius"];
    
    [editDict setObject:@"IOS" forKey:@"devicetype"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [editDict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [editDict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [editDict setObject:@"Household Chores,Delivery/Moving Person" forKey:@"categories"];
    [editDict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userID"];
    
    
    
    NSLog(@"Edit Employer %@",editDict);
    [kAppDelegate showProgressHUD];
    [[NetworkEngine sharedNetworkEngine]OnboardingMultipart:^(id object) {
        
        if ([object[@"status"] integerValue]==1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAppDelegate hideProgressHUD];
                 NSMutableDictionary *dic = [kAppDelegate CreateNonNullDictionary:[object valueForKey:@"data"]];
                [USERDEFAULTS setObject:dic forKey:userData];
                //vinay here-
                [USERDEFAULTS setObject:latitute forKey:AddressLatitude];
                [USERDEFAULTS setObject:longitude forKey:AddressLongitude];
                [self.navigationController popViewControllerAnimated:YES];
            });
           
            
            
        }
        else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
        {
            
            [self CreateToken];
        }
        
    } onError:^(NSError *error) {
         NSLog(@"Error : %@",error);
    } params:editDict];
    
    
    
    
    
}

-(void)CreateToken
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self EditToilerProfile];
             
         } else
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:[object valueForKey:@"message"]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
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
    latitute = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%f",mapItem.placemark.coordinate.longitude];
    //vinay here-
//    [USERDEFAULTS setObject:latitute forKey:AddressLatitude];
//    [USERDEFAULTS setObject:longitude forKey:AddressLongitude];
    
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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
         _addressTblView.hidden = YES;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void) geoCodeUsingAddress:(NSString *)address
{
   CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            
            latitute = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        }
    }];
}

@end
