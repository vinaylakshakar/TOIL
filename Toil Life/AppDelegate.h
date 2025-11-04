//
//  AppDelegate.h
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "Harpy.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate,HarpyDelegate>

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (strong, nonatomic) UIWindow *window;
- (void)showProgressHUD;
-(void)showProgressHUDWithText:(NSString *)text;
- (void)hideProgressHUD;
-(void)showProgressHUDInView:(UIView *)view;
@property (nonatomic, retain) CLLocationManager *locationManager;
-(void)RegisterGuestUser;
-(void)CurrentLocationIdentifier;
-(void)registerForRemoteNotifications;
@property (nonatomic) BOOL isSameTabIndex;
-(NSMutableDictionary *)CreateNonNullDictionary:(NSMutableDictionary *)yourDictionary;

@end

