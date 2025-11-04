//
//  NetworkEngine.m
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "NetworkEngine.h"
#import "AppDelegate.h"
#import "Utility.h"

@implementation NetworkEngine
//@synthesize posted;
static  NetworkEngine *sharedNetworkEngine = nil;
+(id)sharedNetworkEngine
{
    
    if(sharedNetworkEngine == nil)
    {
        sharedNetworkEngine = [[NetworkEngine alloc] init];
    }
    
    return sharedNetworkEngine;
}

-(id)init
{
    
    self = [super init];
    if(self) {
        self.httpManager = [AFHTTPRequestOperationManager manager];
        
        self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript",@"text/plain", nil];
        
        [self.httpManager.requestSerializer setAuthorizationHeaderFieldWithUsername:nil password:nil];
        
    }
    return self;
}



-(void)ValidateOTP:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:@"tok123456" forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"ValidateOTP?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

//-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
//{
//    [kAppDelegate showProgressHUD];
//
//     [self.httpManager.requestSerializer setValue:@"tok123456" forHTTPHeaderField:@"Token"];
//
//    [self.httpManager POST:kBaseURL@"RegisterUser" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//
//         if([responseObject valueForKey:@"message"])
//         {
//             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
//             {
//                 [kAppDelegate hideProgressHUD];
//                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
//             }
//             else completionBlock(responseObject);
//         }
//         else errorBlock(nil);
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         [kAppDelegate hideProgressHUD];
//         errorBlock(error);
//
//     }];
//}

-(void)GetProfile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetProfile?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
//                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)GenerateOTP:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];

    NSLog(@"token--- %@" ,[USERDEFAULTS valueForKey:Token]);
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];

    [self.httpManager POST:kBaseURL@"GenerateOTP?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         NSLog(@"error-%@",error);
         errorBlock(error);

     }];
}

-(void)CreateToken:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"CreateToken" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)OnboardingMultipart:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict
{
        [kAppDelegate showProgressHUD];
       [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
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
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"RoleName\"\r\n\r\n%@",[editDict valueForKey:@"RoleName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AboutMe\"\r\n\r\n%@",[editDict valueForKey:@"AboutMe"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLatitude\"\r\n\r\n%@", [editDict valueForKey:@"AddressLatitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLongitude\"\r\n\r\n%@",[editDict valueForKey:@"AddressLongitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:siteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error==nil)
        {
         NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        completionBlock(dict);
        }
        else{
            [kAppDelegate hideProgressHUD];
            errorBlock(error);
        }
    }]resume];
}

-(void)OnboardingMultipartWithImage:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict
{
    [kAppDelegate showProgressHUD];
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
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
    
    if ([editDict valueForKey:@"image"]!=nil)
    {
        if([[editDict valueForKey:@"image"] isKindOfClass:[UIImage class]])
        {
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        UIImage *uploadImage = [editDict valueForKey:@"image"];
        
        NSData *imageData =UIImageJPEGRepresentation(uploadImage, 0.1);
        
        [postBody appendData:imageData];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    
    //add params-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AboutMe\"\r\n\r\n%@", [editDict valueForKey:@"AboutMe"]]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"RoleName\"\r\n\r\n%@", [editDict valueForKey:@"RoleName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FirstName\"\r\n\r\n%@", [editDict valueForKey:@"FirstName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LastName\"\r\n\r\n%@", [editDict valueForKey:@"LastName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Email\"\r\n\r\n%@", [editDict valueForKey:@"Email"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"MobileNo\"\r\n\r\n%@",[editDict valueForKey:@"MobileNo"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"BusinessName\"\r\n\r\n%@", [editDict valueForKey:@"BusinessName"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"UserAddress\"\r\n\r\n%@", [editDict valueForKey:@"UserAddress"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLatitude\"\r\n\r\n%@", [editDict valueForKey:AddressLatitude]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"AddressLongitude\"\r\n\r\n%@", [editDict valueForKey:AddressLongitude]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"SearchJobRadius\"\r\n\r\n%@", [editDict valueForKey:@"SearchJobRadius"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetoken\"\r\n\r\n%@", [editDict valueForKey:@"devicetoken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"devicetype\"\r\n\r\n%@", [editDict valueForKey:@"devicetype"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n%@", [editDict valueForKey:@"categories"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@", [editDict valueForKey:@"id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pr(@"message data post data %@",postBody);
    
    // add body to post
    [siteRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:siteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error==nil)
        {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            completionBlock(dict);
        }
        else{
            [kAppDelegate hideProgressHUD];
            errorBlock(error);
        }
    }]resume];
}

-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    [self.httpManager.requestSerializer setValue:@"tok123456" forHTTPHeaderField:@"Token"];

    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.httpManager POST:kBaseURL@"Register.aspx" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"Image" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}


-(void)GetJobList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetJobList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)BidForAJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
     NSLog(@"token--- %@" ,[USERDEFAULTS valueForKey:Token]);
    [self.httpManager POST:kBaseURL@"BidForAJob?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetPostedJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetPostedJob?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)HireForJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUDWithText:@"Hiring for job"];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"HireForJob?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetEmployerActiveJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetEmployerActiveJobs?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetToilerList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetToilerList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)DeleteJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"DeleteJob?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetToilerInvites:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetToilerInvites?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)AcceptRejectInvite:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"AcceptRejectInvite?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetEmployerAllJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetEmployerAllJobs?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetBidJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetBidJob?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetToilerActiveJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    NSLog(@"%@ and token is %@",params,[USERDEFAULTS valueForKey:Token]);
    
    [self.httpManager POST:kBaseURL@"GetToilerActiveJobs?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetToilerCompletedJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetToilerCompletedJobs?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetEmployerCompletedJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetEmployerCompletedJobs?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)PostJobMultipartWithImages:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict
{
    [kAppDelegate showProgressHUD];
    NSURL *str=[NSURL URLWithString:@"CreateNewJob.aspx"];
    NSMutableArray *arrPics = [editDict objectForKey:@"ImagesArray"];
    NSString  *value = [editDict objectForKey:@"isForEditJob"];
    bool isForEditJob;
    if([value isEqualToString:@"1"])
    {
        isForEditJob = true;
    }
    else{
        isForEditJob = false;
    }
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
    //[siteRequest addValue:@"1234" forHTTPHeaderField:@"Token"];
    //add body
    NSMutableData *postBody = [NSMutableData data];
    //    pro(@"body made");
    
    if(arrPics.count>=1)
    {
    for (UIImage *image in arrPics)
    {
        //image
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Images\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *imageData =UIImageJPEGRepresentation(image, 0.1);
        
        [postBody appendData:imageData];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    }
    
    
    
    //add params-
    if (isForEditJob)
    {
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"jobID\"\r\n\r\n%@", [editDict valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n%@", [[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"JobTitle\"\r\n\r\n%@", [editDict valueForKey:@"JobTitle"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Category\"\r\n\r\n%@", [editDict valueForKey:@"Category"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"JobDescription\"\r\n\r\n%@", [editDict valueForKey:@"JobDescription"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Budget\"\r\n\r\n%@", [editDict valueForKey:@"Budget"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Latitude\"\r\n\r\n%@", [editDict valueForKey:@"Latitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Longitude\"\r\n\r\n%@", [editDict valueForKey:@"Longitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //vinay here-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"EndDate\"\r\n\r\n%@", [editDict valueForKey:@"EndDate"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //for remove Null in Response-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"CreatedDate\"\r\n\r\n%@", @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pr(@"message data post data %@",postBody);
    
    // add body to post
    [siteRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:siteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error==nil)
        {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            completionBlock(dict);
        }
        else{
            [kAppDelegate hideProgressHUD];
            errorBlock(error);
        }
    }]resume];
}

-(void)GetChat:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetChat?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)SaveMemberChat:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"SaveMemberChat?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)InviteJobMultipartWithImages:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict
{
    [kAppDelegate showProgressHUDWithText:@"Inviting for job"];;
    NSURL *str=[NSURL URLWithString:@"InviteForJob.aspx"];
    NSMutableArray *arrPics = [editDict objectForKey:@"ImagesArray"];
    
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
    //[siteRequest addValue:@"1234" forHTTPHeaderField:@"Token"];
    //add body
    NSMutableData *postBody = [NSMutableData data];
    //    pro(@"body made");
    
    for (UIImage *image in arrPics)
    {
        //image
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Images\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *imageData =UIImageJPEGRepresentation(image, 0.1);
        
        [postBody appendData:imageData];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    //add params-
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ToilerId\"\r\n\r\n%@",[editDict valueForKey:@"ToilerId"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n%@", [[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"JobTitle\"\r\n\r\n%@", [editDict valueForKey:@"JobTitle"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Category\"\r\n\r\n%@", [editDict valueForKey:@"Category"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"JobDescription\"\r\n\r\n%@", [editDict valueForKey:@"JobDescription"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Budget\"\r\n\r\n%@", [editDict valueForKey:@"Budget"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Latitude\"\r\n\r\n%@", [editDict valueForKey:@"Latitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Longitude\"\r\n\r\n%@", [editDict valueForKey:@"Longitude"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"stripetoken\"\r\n\r\n%@", [editDict valueForKey:@"stripetoken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerid\"\r\n\r\n%@", [editDict valueForKey:@"customerid"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //vinay here-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"EndDate\"\r\n\r\n%@", [editDict valueForKey:@"EndDate"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //for remove Null in Response-
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"CreatedDate\"\r\n\r\n%@", @""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pr(@"message data post data %@",postBody);


    // add body to post
    [siteRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:siteRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error==nil)
        {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            completionBlock(dict);
        }
        else{
            [kAppDelegate hideProgressHUD];
            errorBlock(error);
        }
    }]resume];
}

-(void)GetMemberChatList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    [self.httpManager POST:kBaseURL@"GetMemberChatList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
      if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)MarkJobComplete:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"MarkJobCompleted?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)RequestPayment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"SendPaymentRequest?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)MakePaymentByEmployer:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"MakePaymentByEmployer?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)FileDispute:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"FileDispute?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)SaveRating:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"SaveRating?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Logout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"Logout?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

//=================================STRIPE METHOD ==========================

- (void)StripeApiCall:(void (^)(NSDictionary *, NSError *))completion
{
    __block NSDictionary *respCompData = nil;
    
    NSURL *url = [NSURL URLWithString:@"https://connect.stripe.com/oauth/token"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *stringData = [NSString stringWithFormat:@"client_secret=%@&code=%@&grant_type=%@",[_stripeDic valueForKey:@"client_secret"],[_stripeDic valueForKey:@"code"],[_stripeDic valueForKey:@"grant_type"]];
    
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:requestBodyData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        respCompData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        completion(respCompData,nil);
        
    }] resume];
    
    
}


-(void)AddToilerStripeToken:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"UpdateUserStripeAccId?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)GetCardList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUDWithText:@"get card list"];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"GetCustomerData?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)addCard:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUDWithText:@"Adding Card"];
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager POST:kBaseURL@"SaveCard?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"message"])
         {
             if([[responseObject valueForKey:@"message"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}
@end
