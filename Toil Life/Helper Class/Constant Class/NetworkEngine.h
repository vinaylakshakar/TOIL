//
//  NetworkEngine.h
//  Toil Life
//
//  Created by Rajat Lakhina on 21/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^completion_block)(id object);
typedef void(^error_block)(NSError *error);
typedef void (^upload_completeBlock)(NSString *url);
@interface NetworkEngine : NSObject

@property (nonatomic) bool posted;
@property (nonatomic) bool isNewUser;
@property (nonatomic) bool recent;
@property (nonatomic) bool completed;
@property(nonatomic,strong)NSMutableDictionary *stripeDic;
@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;
+(id)sharedNetworkEngine;

-(void)ValidateOTP:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
//-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetProfile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GenerateOTP:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)CreateToken:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetJobList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)BidForAJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetPostedJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)HireForJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetEmployerActiveJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetToilerList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)OnboardingMultipart:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)DeleteJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)OnboardingMultipartWithImage:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict;
-(void)GetToilerInvites:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)AcceptRejectInvite:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetEmployerAllJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetBidJob:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetToilerActiveJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetToilerCompletedJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetEmployerCompletedJobs:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
// create new job
-(void)PostJobMultipartWithImages:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict;
-(void)GetChat:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)SaveMemberChat:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
// invite job
-(void)InviteJobMultipartWithImages:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)editDict;
-(void)GetMemberChatList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)MarkJobComplete:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)FileDispute:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)SaveRating:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)RequestPayment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)MakePaymentByEmployer:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Logout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
- (void)StripeApiCall:(void (^)(NSDictionary *, NSError *))completion;
-(void)AddToilerStripeToken:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetCardList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)addCard:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
@end
