//
//  ChatViewController.m
//  MiRusPROM
//
//  Created by silstone on 10/25/17.
//  Copyright © 2017 SilstoneGroup. All rights reserved.
//

#import "ChatViewController.h"
#import "NetworkEngine.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.automaticallyScrollsToMostRecentMessage = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(255/255.0) green:(102/255.0) blue:(1/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.title = self.recieverNameStr;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.0f, 0.0f);
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.0f, 0.0f);
    
    self.messages = [[NSMutableArray alloc]init];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.senderId = [NSString stringWithFormat:@"%@",[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]];
    //self.senderId = @"74";
    self.senderDisplayName = @"PT-4482GFR";
    [self.tabBarController.tabBar setHidden:YES];
    [self getMessages];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//{
//    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
//    
//    //UIColor *color = [UIColor blackColor]; // select needed color
//    NSString *string = message.senderDisplayName; // the string to colorize
//    NSDictionary *attrDict = @{
//                               NSFontAttributeName : [UIFont systemFontOfSize:10.0],
//                               NSForegroundColorAttributeName : [UIColor blackColor]
//                               };
//    //NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrDict];
//    
//    NSString *userid = @"42";//[NSString stringWithFormat:@"%@",self.userID];
//    if ([message.senderId isEqualToString:userid]) {
//        return nil;
//    }
//    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
//            return nil;
//        }
//    }
//    
//    return attrStr;
//}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message.senderDisplayName];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, message.senderDisplayName.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, message.senderDisplayName.length)];
    //    return attributedString;
    return [self.senderId isEqualToString:message.senderId]? nil : attributedString;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    return [self.senderId isEqualToString:message.senderId]? 0 : 20 ;
}


-(void) addMessage:(NSString *)Id withname:(NSString *)name  withText:(NSString *)text{
    NSMutableArray *othersMessage = [[NSMutableArray alloc]init];
    
    [othersMessage addObject:[JSQMessage messageWithSenderId:Id displayName:name text:text]];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date{
    
    [self addMessage:text:senderId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _messages.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *dic = [_messages objectAtIndex:indexPath.row];
    //  }
    if(true)
    {
        
        [cell.textView setTextColor:[UIColor whiteColor]];
        cell.textView.text = dic.text;
        
    }
    
    return cell;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.messages objectAtIndex:indexPath.item];
    
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesBubbleImageFactory *imgFactory = [[JSQMessagesBubbleImageFactory alloc]init];
    // for(int i = 0; i <= _messages.count; i++){
    JSQMessage *dic = [_messages objectAtIndex:indexPath.row];
    //  }
    
    //NSLog(@"%@,%@",dic,[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]);
    NSString *userID =[NSString stringWithFormat:@"%@",[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"]];
    
    if([dic.senderId isEqualToString:userID])
    {
        return [imgFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:0.99 green:0.40 blue:0.13 alpha:1.0]];
        
    }
    else{
        
        //return [imgFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:255.0f/255.0f green:95.0f/255.0f blue:98.0f/255.0f alpha:1.0f]];
        //vinay here-
        return [imgFactory incomingMessagesBubbleImageWithColor:[UIColor darkGrayColor]];
    }
    

}
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

-(void)initBubbles{
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

-(void)addMessage:(NSString *)message :(NSString *)senderID
{

        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"fromUserId"];
        [dict setObject:self.recieverIDStr forKey:@"toUserId"];
        [dict setObject:message forKey:@"msg"];
        [dict setObject:self.jobIDStr forKey:@"jobId"];
        
        NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]SaveMemberChat:^(id object)
         {
             NSLog(@"%@",object);
             
             if ([[object valueForKey:@"message"] isEqualToString:@"success"])
             {
                 [kAppDelegate hideProgressHUD];
                         NSLog(@"add mesager Done");
                         [self.messages addObject:[JSQMessage messageWithSenderId:senderID displayName:@"" text:message]];
                         [self finishSendingMessage];
                         [self.collectionView reloadData];
                 
                 
             }
             
             
             
             
         }
                                            onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];

}

-(void)getMessages
{
  
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[[USERDEFAULTS valueForKey:userData] valueForKey:@"Id"] forKey:@"fromUserId"];
        [dict setObject:self.recieverIDStr forKey:@"toUserId"];
        [dict setObject:self.jobIDStr forKey:@"jobId"];
        
        NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]GetChat:^(id object)
         {
             NSLog(@"%@",object);
             
             if ([[object valueForKey:@"message"] isEqualToString:@"success"])
             {
                 [kAppDelegate hideProgressHUD];
                         NSLog(@"get messages");
                         [self.messages removeAllObjects];
                 
                         NSMutableArray *messageArray = [[object valueForKey:@"data"] mutableCopy];
                 
                         for (int i=0; i<[messageArray count]; i++) {
                             NSMutableDictionary *dic = [messageArray objectAtIndex:i];
                             
                             NSString *senderIDStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"FromUserId"]];
                             [self.messages addObject:[JSQMessage messageWithSenderId:senderIDStr displayName:@"" text:[dic valueForKey:@"ChatMessage"]]];
                         }
                         [self.collectionView reloadData];

                 
             }else if([[object valueForKey:@"message"] isEqualToString:@"No Data Found!"])
             {
                 [kAppDelegate hideProgressHUD];
               
             }
             else if([[object valueForKey:@"message"] isEqualToString:@"Invalid Token!"])
             {
                 [self CreateToken:@"getMessages"];
             }else if([[object valueForKey:@"message"] isEqualToString:@"User Can Not Chat!"])
             {
                  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Toil.Life"
                                   message:@"Messaging is disabled!"
                                   preferredStyle:UIAlertControllerStyleAlert];
                                
                 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
                                [alert addAction:cancel];
                                [self presentViewController:alert animated:YES completion:nil];
             }
             
             
             
             
         }
                                                     onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];
    }
}

-(void)CreateToken:(NSString*)type
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:clientSecretValue forKey:@"clientSecret"];
    
    [[NetworkEngine sharedNetworkEngine]CreateToken:^(id object)
     {
         
         if ([[object valueForKey:@"message"] isEqualToString:@"success"])
         {
             
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:Token];
             if ([type isEqualToString:@"getMessages"]) {
                 [self getMessages];
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


@end
