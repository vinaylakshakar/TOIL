//
//  EditOccupationViewController.m
//  Toil Life
//
//  Created by Rajat Lakhina on 23/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "EditOccupationViewController.h"

@interface EditOccupationViewController ()
{
    NSMutableArray *arrKeywords;
}
@end

@implementation EditOccupationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrKeywords = [[NSMutableArray alloc]init];
//    if(IS_iPHONE_5){
//        mainScl.contentSize = CGSizeMake(mainScl.frame.size.width, 650);
//    }
    
    // Do any additional setup after loading the view.
    [self setLayout];
}
-(void)setLayout
{
    for (NSString *category in self.occupationArray)
    {
        
        if ([category isEqualToString:@"Household Chores"]) {
            [arrKeywords addObject:@"Household Chores"];
            _choresBtn.selected = YES;
        }
        if ([category isEqualToString:@"Delivery/Moving Person"]) {
            [arrKeywords addObject:@"Delivery/Moving Person"];
            _deliveryBtn.selected = YES;
        }
        if ([category isEqualToString:@"Odd Jobs"]) {
            [arrKeywords addObject:@"Odd Jobs"];
            _oddJobsBtn.selected = YES;
        }
        if ([category isEqualToString:@"Trades and Construction"]) {
            [arrKeywords addObject:@"Trades and Construction"];
            _tradeBtn.selected = YES;
        }
        if ([category isEqualToString:@"Farm Hand"]) {
             [arrKeywords addObject:@"Farm Hand"];
            _farmBtn.selected = YES;
        }
        if ([category isEqualToString:@"Service/Retail Industry"]) {
             [arrKeywords addObject:@"Service/Retail Industry"];
            _serviceBtn.selected = YES;
        }
    }
    
    NSLog(@"%@",arrKeywords);
}

#pragma mark - Button Action
-(IBAction)backclick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNextBtn:(UIButton *)sender {
    
    if(_tradeBtn.selected || _farmBtn.selected || _serviceBtn.selected || _choresBtn.selected || _deliveryBtn.selected || _oddJobsBtn.selected){
        
        [self EditOccupation];
        
    }
    else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                       message:@"Please select an occupation."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - Api Method


- (void)EditOccupation
{
    NSLog(@"mobile no. %@",[USERDEFAULTS valueForKey:MobileNo]);
    //[kAppDelegate showProgressHUD];
    
    NSLog(@"Profile %@",self.profileDict);
    NSString * categories = [arrKeywords componentsJoinedByString:@","];
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
    
    //add params-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"RoleName\"\r\n\r\n%@",[self.profileDict valueForKey:@"RoleName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AboutMe\"\r\n\r\n%@",[self.profileDict valueForKey:@"AboutMe"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FirstName\"\r\n\r\n%@", [self.profileDict valueForKey:@"FirstName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LastName\"\r\n\r\n%@", [self.profileDict valueForKey:@"LastName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Email\"\r\n\r\n%@", [self.profileDict valueForKey:@"Email"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"MobileNo\"\r\n\r\n%@", [self.profileDict valueForKey:@"MobileNo"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"BusinessName\"\r\n\r\n%@",[self.profileDict valueForKey:@"BusinessName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserAddress\"\r\n\r\n%@", [self.profileDict valueForKey:@"UserAddress"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLatitude\"\r\n\r\n%@", [USERDEFAULTS valueForKey:AddressLatitude]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLongitude\"\r\n\r\n%@",[USERDEFAULTS valueForKey:AddressLongitude]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"SearchJobRadius\"\r\n\r\n%@", [self.profileDict valueForKey:@"SearchJobRadius"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetoken\"\r\n\r\n%@", [self.profileDict valueForKey:@"devicetoken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetype\"\r\n\r\n%@", [self.profileDict valueForKey:@"devicetype"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n%@", categories] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n%@", [self.profileDict valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
             [self EditOccupation];
             
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



- (IBAction)actionChores:(UIButton *)sender {
    
    if(_choresBtn.selected){
        
        _choresBtn.selected = NO;
        [arrKeywords removeObject:@"Household Chores"];
    }
    else{
        _choresBtn.selected = YES;
        [arrKeywords addObject:@"Household Chores"];
    }
    
}

- (IBAction)actionDelivery:(UIButton *)sender {
    
    if(_deliveryBtn.selected){
        
        _deliveryBtn.selected = NO;
        [arrKeywords removeObject:@"Delivery/Moving Person"];
    }
    else{
        
        _deliveryBtn.selected = YES;
        [arrKeywords addObject:@"Delivery/Moving Person"];
    }
    
}

- (IBAction)actionOddJobs:(UIButton *)sender {
    
    if( _oddJobsBtn.selected){
        _oddJobsBtn.selected = NO;
        [arrKeywords removeObject:@"Odd Jobs"];
    }
    else{
        _oddJobsBtn.selected = YES;
        [arrKeywords addObject:@"Odd Jobs"];
    }
    
}

- (IBAction)actionTrade:(id)sender {
    
    if(_tradeBtn.selected){
        _tradeBtn.selected = NO;
        [arrKeywords removeObject:@"Trades and Construction"];
        
    }
    else{
        _tradeBtn.selected = YES;
        [arrKeywords addObject:@"Trades and Construction"];
    }
    
}

- (IBAction)actionFarm:(UIButton *)sender {
    
    if(_farmBtn.selected){
        _farmBtn.selected = NO;
        [arrKeywords removeObject:@"Farm Hand"];
    }
    else{
        _farmBtn.selected = YES;
        [arrKeywords addObject:@"Farm Hand"];
    }
    
}

- (IBAction)actionService:(UIButton *)sender {
    
    if(_serviceBtn.selected){
        
        _serviceBtn.selected = NO;
        [arrKeywords removeObject:@"Service/Retail Industry"];
        
    }
    else{
        _serviceBtn.selected = YES;
        
        [arrKeywords addObject:@"Service/Retail Industry"];
    }
    
}


@end
