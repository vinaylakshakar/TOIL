//
//  CreditCardViewController.h
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/STPAddCardViewController.h>

@protocol CardPaymentDelegate <NSObject>
@required
-(void)PaymentCompleted:(NSTimer *)token;
@end

@interface CreditCardViewController : UIViewController<UIGestureRecognizerDelegate,STPAddCardViewControllerDelegate>
{
    id <CardPaymentDelegate> _cardDelegate;
    
}
@property (nonatomic,strong) id cardDelegate;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic)bool fromCreateJob;
@property (weak, nonatomic) IBOutlet UILabel *navicationTlytleLnl;

@property (weak, nonatomic) IBOutlet UITableView *cardTblView;
@property (strong, nonatomic) NSMutableArray *getUserCards;

@property(nonatomic)bool hireForJob;


@end
