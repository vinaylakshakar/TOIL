//
//  CreditCardViewController.m
//  User
//
//  Created by iCOMPUTERS on 18/01/17.
//  Copyright © 2017 iCOMPUTERS. All rights reserved.
//

#import "CreditCardViewController.h"
//#import "Colors.h"
//#import "CSS_Class.h"
//#import "config.h"
//#import "CommenMethods.h"
#import "Stripe.h"
#import "AppDelegate.h"
#import "CardCell.h"
//#import "Constants.h"
//#import "ViewController.h"


@interface CreditCardViewController ()
{
    AppDelegate *appDelegate;
}

@end

@implementation CreditCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _getUserCards = [[NSMutableArray alloc]init];
    [self setDesignStyles];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(1/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
     [self getAllCard];
    
    
   
}


- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

-(IBAction)addCardVC:(id)sender
{
    STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
    addCardViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LocalizationUpdate];
    
}

- (void)LocalizationUpdate{
//    _navicationTlytleLnl.text = @"Add credit or debit card";
//    _cardLbl.text = @"Card number";
//    [_addBtn setTitle:@"ADD" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtn:(id)sender
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];

//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addBtn:(id)sender
{}

-(void)dismisView
{
   
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setDesignStyles
{
//    [CSS_Class APP_Blackbutton:_addBtn];
//
//    [CSS_Class APP_fieldValue_Small:_cardLbl];
//    [CSS_Class APP_fieldValue_Small:_countryLbl];
//
//    [CSS_Class APP_textfield_Outfocus:_cardText];
//    [CSS_Class APP_textfield_Outfocus:_countryText];
//    [CSS_Class APP_textfield_Outfocus:_dateText];
//    [CSS_Class APP_textfield_Outfocus:_cvvText];

//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    _cardText.leftView = paddingView;
//    _cardText.leftViewMode = UITextFieldViewModeAlways;
}


-(NSString*)formatNumber:(NSString*)mobileNumber
{
    @try
    {
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        int length = (int)[mobileNumber length];
        if(length > 10)
        {
            mobileNumber = [mobileNumber substringFromIndex: length-10];
        }
        return mobileNumber;
    }
    @catch (NSException *exception)
    {
    }
    @finally
    {
        
    }
}


- (int)getLength:(NSString*)mobileNumber
{
    @try
    {
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        int length = (int)[mobileNumber length];
        
        return length;
        
    }
    @catch (NSException *exception)
    {
    
    }
    @finally
    {
        
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[CSS_Class APP_textfield_Infocus:textField];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //[CSS_Class APP_textfield_Outfocus:textField];
    return YES;
}

-(void)showAlert:(NSString *)title :(NSString *)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];
    
    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    // Dismiss add card view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController didCreateToken:(STPToken *)token completion:(STPErrorBlock)completion {
    
    
    NSArray *filteredData = [_getUserCards filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CardNo contains[c] %@)", token.card.last4]];
    NSMutableDictionary *dis = [[NSMutableDictionary alloc]init];
    if(filteredData.count>=1)
    {
        // send customer ID
        NSMutableDictionary *dict = [filteredData objectAtIndex:0];
        [dis setObject:@"" forKey:@"TokenID"];
        [dis setObject:[dict objectForKey:@"CustomerId"] forKey:@"CustomerID"];
    }
    else{
        // send token ID
        [dis setObject:token.tokenId forKey:@"TokenID"];
        [dis setObject:@"" forKey:@"CustomerID"];
       
    }
    
     [appDelegate showProgressHUDWithText:@"payment processing"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        appDelegate.progressHUD.customView = imageView;
        appDelegate.progressHUD.mode = MBProgressHUDModeCustomView;
        appDelegate.progressHUD.label.text = @"Completed";
        [appDelegate.progressHUD hideAnimated:YES afterDelay:1.f];
    });
    
    
    //[STPCustomerContext attachSourceToCustomer]
     [self dismissViewControllerAnimated:YES completion:nil];
   if(!self.fromCreateJob)
   {
       [NSTimer scheduledTimerWithTimeInterval:1.0 target:self.cardDelegate
                                      selector:@selector(PaymentCompleted:) userInfo:dis repeats:NO];
       
       [self performSelector:@selector(dismisView) withObject:nil afterDelay:1.0 ];
   }
   else{
       // call Api for Add card
       [self AddCard:token.tokenId];
   }
  
}


-(void)getAllCard
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetCardList:^(id object)
     {
         NSLog(@"%@",object);
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             _getUserCards = [object valueForKey:@"data"];
             [self addNewValue];
             
         }
         else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"getcard" :@""];
         }
     }
        onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


-(void)AddCard:(NSString *)token
{
    [kAppDelegate showProgressHUDWithText:@"Adding Card"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"userid"];
    [dict setObject:token forKey:@"stripetoken"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]addCard:^(id object)
     {
         NSLog(@"%@",object);
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
              _getUserCards = [object valueForKey:@"data"];
//             [self addNewValue];
             [self getAllCard];
             
         }
         else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
         {
             [self CreateToken:@"addcard" :token];
         }
         else{
             [Utility showAlertMessage:@"Toil.Life" message:[object valueForKey:@"message"]];
         }
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)addNewValue
{
    NSMutableArray *allValues = [[NSMutableArray alloc]init];
    for (int i=0; i<_getUserCards.count; i++) {
        NSMutableDictionary *ds = [_getUserCards objectAtIndex:i];
        NSArray *filteredData = [allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CardNo contains[c] %@)", [ds valueForKey:@"CardNo"]]];
        if (filteredData.count<1) {
            // add dictionary
            [allValues addObject:ds];
        }
    }
    self.getUserCards = allValues;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"New Card" forKey:@"CardNo"];
    NSMutableArray *arr = [self.getUserCards mutableCopy];
    [arr addObject:dict];
    _getUserCards = arr;
    [self.cardTblView reloadData];
}

-(void)CreateToken:(NSString *)type :(NSString *)token
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
             if([type isEqualToString:@"addcard"])
             {
                 [self AddCard:token];
             }
             else{
             [self getAllCard];
             }
             
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


#pragma mark - Table View Delegates and Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.getUserCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cardcell";
    CardCell *cell = [self.cardTblView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableDictionary *dic = [self.getUserCards objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([[dic valueForKey:@"CardType"] isEqualToString:@"Visa"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_visa"]];
    }
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"MasterCard"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_mastercard"]];
    }
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"American Express"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"amex"]];
    }
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"JCB"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_jcb"]];
    }
    
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"unionpay"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_unionpay_en"]];
    }
    
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"Discover"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_discover"]];
    }
    else if ([[dic valueForKey:@"CardType"] isEqualToString:@"Diners Club"])
    {
        [cell.cardImage setImage:[UIImage imageNamed:@"stp_card_diners"]];
    }
    if([[dic valueForKey:@"CardNo"] isEqualToString:@"New Card"])
    {
        cell.cardNumberLbl.text = @"Add a New Card";
        
    }
    else{
    cell.cardNumberLbl.text = [NSString stringWithFormat:@"XXXX - XXXX - XXXX - %@",[dic valueForKey:@"CardNo"]];
    }
    
    if (self.fromCreateJob)
    {
        [cell.cardBtn setHidden:YES];
        if([[dic valueForKey:@"CardNo"] isEqualToString:@"New Card"])
        {
            [cell.cardBtn setHidden:NO];
            cell.cardBtn.tag = indexPath.row;
            [cell.cardBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else
    {
        cell.cardBtn.tag = indexPath.row;
        [cell.cardBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}

-(void)clickItem:(UIButton *)Btn
{
    int tag = (int)Btn.tag;
    
    NSMutableDictionary *dic = [self.getUserCards objectAtIndex:tag];
    if([[dic valueForKey:@"CardNo"] isEqualToString:@"New Card"])
    {
        // add new card
        STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
        addCardViewController.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else{
        NSMutableDictionary *dic = [self.getUserCards objectAtIndex:tag];
        NSMutableDictionary *dis = [[NSMutableDictionary alloc]init];
        [dis setObject:@"" forKey:@"TokenID"];
        [dis setObject:[dic objectForKey:@"CustomerId"] forKey:@"CustomerID"];
        [appDelegate showProgressHUDWithText:@"payment processing"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self.cardDelegate
                                       selector:@selector(PaymentCompleted:) userInfo:dis repeats:NO];
        
        [self performSelector:@selector(dismisView) withObject:nil afterDelay:1.0 ];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}




@end
