//
//  ToilerProfilePictureViewController.h
//  Toil Life
//
//  Created by Developer on 10/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToilerProfilePictureViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) NSMutableDictionary *toilerInfoDict;


@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;


@end
