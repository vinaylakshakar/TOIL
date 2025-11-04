//
//  EmployerProfilePictureViewController.h
//  Toil Life
//
//  Created by Rajat Lakhina on 11/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployerProfilePictureViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) NSMutableDictionary *employerInfoDict;

@end
