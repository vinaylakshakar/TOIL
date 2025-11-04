//
//  EditProfileDetailsViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 23/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EditProfileDetailsViewController.h"

@interface EditProfileDetailsViewController ()
{
    NSMutableArray *arrDistance;
}
@end

@implementation EditProfileDetailsViewController

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
    
    [self setLayout];
}

-(void)setLayout
{
    NSLog(@"%@",self.employerDict);
    self.txtFieldFirstName.text =[self.employerDict valueForKey:@"FirstName"];
    self.txtFieldLastName.text =[self.employerDict valueForKey:@"LastName"];
    self.txtFieldRecoveryEmail.text =[self.employerDict valueForKey:@"Email"];
    self.txtFieldBussinessName.text =[self.employerDict valueForKey:@"BusinessName"];
    self.txtViewAddress.text =[self.employerDict valueForKey:@"UserAddress"];
    NSString *radiusStr = [NSString stringWithFormat:@"%@",[self.employerDict valueForKey:@"SearchJobRadius"]];
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
    if([_txtFieldAddress.text isEqualToString:@""]){
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
    else{
        LoginProcess *sharedManager = [LoginProcess sharedManager];
        bool emailValid = [sharedManager emailValidate:_txtFieldRecoveryEmail];
        if(emailValid){
            
           // [self.navigationController popViewControllerAnimated:YES];
            [self EditEmployerProfile];
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


- (void)EditEmployerProfile
{
        //[kAppDelegate showProgressHUD];
       NSString *radius = [arrDistance objectAtIndex:[self.distancePickerView selectedRowInComponent:0]];
        NSMutableDictionary *editDict = [[NSMutableDictionary alloc]init];
        [editDict setObject:@"Employer" forKey:@"RoleName"];
        [editDict setObject:self.txtFieldFirstName.text forKey:@"FirstName"];
        [editDict setObject:self.txtFieldLastName.text forKey:@"LastName"];
    [editDict setObject:self.txtFieldRecoveryEmail.text forKey:@"Email"];
    [editDict setObject:[USERDEFAULTS valueForKey:MobileNo] forKey:@"MobileNo"];
    [editDict setObject:self.txtFieldBussinessName.text forKey:@"BusinessName"];
    [editDict setObject:self.txtViewAddress.text forKey:@"UserAddress"];
    [editDict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"AddressLatitude"];
    [editDict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"AddressLongitude"];
    [editDict setObject:radius forKey:@"SearchJobRadius"];
//    [editDict setObject:@"" forKey:@"devicetoken"];
//    [editDict setObject:@"" forKey:@"devicetype"];
    
    [editDict setObject:@"IOS" forKey:@"devicetype"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [editDict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
        
    }
    else{
        [editDict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"devicetoken"];
        
    }
    [editDict setObject:@"" forKey:@"categories"];
    [editDict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userID"];

    
    
    NSLog(@"Edit Employer %@",editDict);

        //http://localscompass.silappdevops.com/services/update_user_image.php?user_id=1
        //http://3.214.38.142/Register.aspx
        //NSString *str=[kBaseURL stringByAppendingFormat:@"Register.aspx"];
        NSURL *str=[NSURL URLWithString:@"onboarduser.aspx"];
        
        NSString *newString = [str.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *urlString = [NSString stringWithFormat:kBaseMultipartUrl@"%@",newString];
        
        
        NSURL *siteURL = [[NSURL alloc] initWithString:urlString];
        
        // create the connection
        NSMutableURLRequest *siteRequest = [NSMutableURLRequest requestWithURL:siteURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
        
        // change type to POST (default is GET)
        [siteRequest setHTTPMethod:@"POST"];
        
        // just some random text that will never occur in the body
        NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
        
        // header value
        NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                    stringBoundary];
        
        // set header
        [siteRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
        // set token
        [siteRequest addValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
        
        //add body
        NSMutableData *postBody = [NSMutableData data];
        //    pro(@"body made");
        
        //image
//        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
//
//        [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//        NSData *imageData =UIImageJPEGRepresentation(_profilePicture.image, 0.1);
//
//        [postBody appendData:imageData];
//        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
        //add params-
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"RoleName\"\r\n\r\n%@",[editDict valueForKey:@"RoleName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FirstName\"\r\n\r\n%@", [editDict valueForKey:@"FirstName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LastName\"\r\n\r\n%@", [editDict valueForKey:@"LastName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Email\"\r\n\r\n%@", [editDict valueForKey:@"Email"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"MobileNo\"\r\n\r\n%@", [editDict valueForKey:@"MobileNo"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"BusinessName\"\r\n\r\n%@",[editDict valueForKey:@"BusinessName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserAddress\"\r\n\r\n%@", [editDict valueForKey:@"UserAddress"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLatitude\"\r\n\r\n%@", [USERDEFAULTS valueForKey:AddressLatitude]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLongitude\"\r\n\r\n%@",[USERDEFAULTS valueForKey:AddressLongitude]] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"SearchJobRadius\"\r\n\r\n%@", [editDict valueForKey:@"SearchJobRadius"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetoken\"\r\n\r\n%@", [editDict valueForKey:@"devicetoken"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetype\"\r\n\r\n%@", [editDict valueForKey:@"devicetype"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n%@", [editDict valueForKey:@"categories"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n%@", [editDict valueForKey:@"userID"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"\r\n\r\n%@", @""] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // final boundary
        [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //pr(@"message data post data %@",postBody);
        
        // add body to post
        [siteRequest setHTTPBody:postBody];
        
        NSURLResponse *response;
        NSError *error;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:siteRequest
                                                   returningResponse:&response
                                                               error:&error];
        
        NSString *myString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dict);
        
        
        if ([dict[@"status"] integerValue]==1) {
            
            // UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [kAppDelegate hideProgressHUD];
             NSMutableDictionary *dic = [kAppDelegate CreateNonNullDictionary:[dict valueForKey:@"data"]];
            [USERDEFAULTS setObject:dic forKey:userData];
            [USERDEFAULTS synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else if([[dict valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
        {
            
            [self CreateToken];
        }
        
    
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
             [self EditEmployerProfile];
             
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
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mapItem = [searchArr objectAtIndex:indexPath.row];
    _txtViewAddress.text = [NSString stringWithFormat:@"%@",[[mapItem placemark] title]];
    _addressTblView.hidden = YES;
    _txtViewAddress.textColor = [UIColor blackColor];
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == _txtViewAddress)
    {
        if([_txtViewAddress.text isEqualToString:@"Add Location"]){
            
            _txtViewAddress.text = @"";
            _txtViewAddress.textColor = [UIColor blackColor];
            
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



@end
