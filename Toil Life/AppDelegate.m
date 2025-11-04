//
//  AppDelegate.m
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import <Stripe/Stripe.h>


//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()
{
    bool isLoggedIn;
    bool isEmployer;
    Reachability *networkReachability;
    NetworkStatus networkStatus;
    CLGeocoder *geocoder;
    NSString *Clatitude;
    NSString *Clongitude,*countryStr;
    CLPlacemark *placemark;
    UIStoryboard *storyboard;
}
@end
@implementation AppDelegate
@synthesize locationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //NetworkEngine *sharedNetwork = [NetworkEngine sharedNetworkEngine];

//    [Fabric with:@[[Crashlytics class]]];
    // Use Firebase library to configure APIs
    [FIRApp configure];
    //vinay here-
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:stripe_Publish_Key];
    //[STPAPIClient sharedClient].publishableKey = stripe_Publish_Key;

    
    [self CurrentLocationIdentifier];
    //Rajat Here
    [self registerForRemoteNotifications];
    //[self registerForRemoteNotificationsFCM:application];
    [FIRMessaging messaging].delegate = self;
    
    storyboard = [self grabStoryboard];
    isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyLoggedIn"];
    isEmployer = [[NSUserDefaults standardUserDefaults] boolForKey:@"isEmployer"];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if(isLoggedIn)
    {
        
        if(isEmployer)
        {
            EmployerTabbarViewController *toilerTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"EmployerTabbarVC"];
            self.window.rootViewController = toilerTabBarVC;
            toilerTabBarVC.selectedIndex = 2; 
        }
        else
        {
            ToilerTabBarViewController *toilerTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"ToilerTabbarVC"];
            self.window.rootViewController = toilerTabBarVC;
            toilerTabBarVC.selectedIndex = 2;
            
        }
        
    }
    else
    {
        
        LoginNavigationViewController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
        self.window.rootViewController = navigationController;
        
    }
    [self.window makeKeyAndVisible];
    //vinay here-
    [self checkversionInDidFinishLounching];
    return YES;
}

-(void)checkversionInDidFinishLounching{
    // Present Window before calling Harpy
        [self.window makeKeyAndVisible];

        // Set the UIViewController that will present an instance of UIAlertController
        [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];

        // Perform check for new version of your app
        [[Harpy sharedInstance] checkVersion];
    
}



- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    if (IS_STANDARD_IPHONE_X) {
//        storyboard = [UIStoryboard storyboardWithName:@"StoryboardX" bundle:nil];
        NSLog(@"Iphone X.");
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    //vinay here-
//    else if (IS_iPHONE_5)
//    {
//        storyboard = [UIStoryboard storyboardWithName:@"Main5x" bundle:nil];
//
//
//    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    
    return storyboard;
}

-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        if(IS_OS_8_OR_LATER) {
            
            [locationManager requestWhenInUseAuthorization];
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        [locationManager startUpdatingLocation];
    }
    [locationManager startUpdatingLocation];
    
    //------
}

-(void)RegisterGuestUser
{
    LoginNavigationViewController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
    self.window.rootViewController = navigationController;
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            //             NSLog(@"%@",[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude]);
            Clatitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            Clongitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            
            Clatitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
            Clongitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
            NSLog(@"%@",Clatitude);
            NSLog(@"%@",Clongitude);
                        NSLog(@"country %@",placemark.country);
            countryStr = [NSString stringWithFormat:@"%@",placemark.country];
            [USERDEFAULTS setObject:Clatitude forKey:AddressLatitude];
            [USERDEFAULTS setObject:Clongitude forKey:AddressLongitude];
            


        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
        NSLog(@"Cannot find the location.");
    [USERDEFAULTS setObject:@"30.596404" forKey:AddressLatitude];
    [USERDEFAULTS setObject:@"76.843266" forKey:AddressLongitude];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    /*
         Perform check for new version of your app
         Useful if user returns to you app from background after being sent tot he App Store,
         but doesn't update their app before coming back to your app.

          ONLY USE THIS IF YOU ARE USING *HarpyAlertTypeForce*

          Also, performs version check on first launch.
         */
        [[Harpy sharedInstance] checkVersion];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Application is now active");
    /*
         Perform daily check for new version of your app
         Useful if user returns to you app from background after extended period of time
          Place in applicationDidBecomeActive:

          Also, performs version check on first launch.
         */
        [[Harpy sharedInstance] checkVersionDaily];

        /*
         Perform weekly check for new version of your app
         Useful if you user returns to your app from background after extended period of time
         Place in applicationDidBecomeActive:

         Also, performs version check on first launch.
         */
        [[Harpy sharedInstance] checkVersionWeekly];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)hexadecimalStringFromData:(NSData *)data
{
    NSUInteger dataLength = data.length;
    if (dataLength == 0) {
        return nil;
    }
      
    const unsigned char *dataBuffer = data.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//
//    //NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    //vinay here-
//    NSString *token;
//    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"13.0")) {
//        // code here
//         token = [self hexadecimalStringFromData:deviceToken];
//    }else
//    {
//        token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    }
//
//    NSLog(@"token is: %@",token);
//
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [[NSUserDefaults standardUserDefaults]setValue:token forKey:deviceId];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//}

-(void)registerForRemoteNotifications
{
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }

    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    [[NSUserDefaults standardUserDefaults]setValue:fcmToken forKey:deviceId];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

//-(void)registerForRemoteNotifications
//{
//     if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
//     {
//         //        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//         //        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
//         //                              completionHandler:^(BOOL granted, NSError *error)
//         //         {
//         //             if (error == nil) [[UIApplication sharedApplication] registerForRemoteNotifications];
//         //         }];
//
//         //vinay here -
//         UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//         center.delegate = self;
//         [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
//             if( !error ){
//
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                    [[UIApplication sharedApplication] registerForRemoteNotifications];
//                 });
//
//             }
//         }];
//     }
//    else {
//        // Code for old versions
//
//        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                        UIUserNotificationTypeBadge |
//                                                        UIUserNotificationTypeSound);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//
//
//
//
//    }
//
//}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
    
    
    //    if ([[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"]  rangeOfString:@"Property Deleted"].location == NSNotFound) {
    //
    //        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    //
    //    }
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Server Error"
                                 
//                                 message:[NSString stringWithFormat:@", error: %@", error]
                                 
                                 message:[NSString stringWithFormat:@"We are unable to create a session due to some internal token error. Please try after some time."]

                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * yesButton = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                     
                                     
                                     
                                 }];
    
    [alert addAction:yesButton];
    
    // [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"notification info-%@",userInfo);
    
}


//progressHUD

-(void)showProgressHUD
{
    //    [self createProgressHud];
    //    [self.window bringSubviewToFront:_progressHUD];
    //    [_progressHUD show:YES];
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Toil.Life" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [self.window bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}

-(void)showProgressHUDWithText:(NSString *)text
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Toil.Life" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [self.window bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        _progressHUD.mode = MBProgressHUDModeIndeterminate;
        _progressHUD.label.text = text;
        
    }
}

#pragma progresshud method-

-(void)showProgressHUDInView:(UIView *)view
{
    //    [self createProgressHud];
    //    [self.window bringSubviewToFront:_progressHUD];
    //    [_progressHUD show:YES];
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Toil.Life" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [view bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}


//Hide Progress HUD
-(void)hideProgressHUD
{
    [_progressHUD hideAnimated:YES];
//    [_progressHUD show:NO];
//    [_progressHUD hide:YES];
}
//Create Progress HUD
-(void)createProgressHud
{
    if(_progressHUD)
    {
        _progressHUD.label.text = @"Loading...";
        return;
    }
    else
    {
        _progressHUD=[[MBProgressHUD alloc]initWithView:self.window.rootViewController.view];
        _progressHUD.label.text = @"Loading...";
        [self.window addSubview:_progressHUD];
    }
}


//================== STRIPE METHOD ==============================

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *accesstoken = [[[url query] componentsSeparatedByString:@"="] objectAtIndex:1];
    [[NSUserDefaults standardUserDefaults]setObject:accesstoken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self callApi:accesstoken];
    
    return YES;
}

- (void)callApi:(NSString *)code
{
    NetworkEngine *sharedNetwork;
    sharedNetwork = [NetworkEngine sharedNetworkEngine];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
     [dict setValue:stripe_Secret_Key forKey:@"client_secret"];
    [dict setValue:code forKey:@"code"];
    [dict setValue:@"authorization_code" forKey:@"grant_type"];
    sharedNetwork.stripeDic = dict;
    
    [self showProgressHUD];
    [[NetworkEngine sharedNetworkEngine] StripeApiCall:^(NSDictionary *result, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
            if([result valueForKey:@"error"] != nil) {
                // The key existed... error exist
                NSLog(@"stripe-%@",result);
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Internal Server Error"
//                                                                               message:[result valueForKey:@"error"]
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
                //vinay here-
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:[result valueForKey:@"error"]
                                                                               message:[result valueForKey:@"error_description"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                
            }
            else {
                //  joy...
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"Stripe_Info"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self UploadAccessToken:[result valueForKey:@"stripe_user_id"]];
               
                
            }
        });
        
    }];
    
}

-(void)UploadAccessToken:(NSString *)token
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];

    [dict setObject:token forKey:@"stripeaccid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]AddToilerStripeToken:^(id object)
     {
         NSLog(@"%@",object);
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateStripe" object:nil];
             
             
         }else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken];
         }
     }
                                           onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


-(void)CreateToken
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
              [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             [self UploadAccessToken: [[USERDEFAULTS objectForKey:@"Stripe_Info"] valueForKey:@"stripe_user_id"]];
             
         } else
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                                                            message:[object valueForKey:@"message"]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
             [alert addAction:cancel];
             [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
         }
         
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(NSMutableDictionary *)CreateNonNullDictionary:(NSMutableDictionary *)yourDictionary
{
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [yourDictionary allKeys])
    {
        if (![[yourDictionary objectForKey:key] isKindOfClass:[NSNull class]])
        {
            [prunedDictionary setObject:[yourDictionary objectForKey:key] forKey:key];
        }
        else{
            [prunedDictionary setObject:@"" forKey:key];
        }
    }
    
    return prunedDictionary;
}

@end
