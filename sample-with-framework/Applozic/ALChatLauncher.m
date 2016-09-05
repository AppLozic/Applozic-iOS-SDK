//
//  MBChatManager.m
//  Applozic
//
//  Created by devashish on 21/12/2015.
//  Copyright © 2015 applozic Inc. All rights reserved.
//



#import "ALChatLauncher.h"
#import "ALUserDefaultsHandler.h"
#import "ALApplozicSettings.h"
#import "ALChatViewController.h"
#import "ALUser.h"
#import "ALRegisterUserClientService.h"
#import "ALMessageClientService.h"


@interface ALChatLauncher ()

@end

@implementation ALChatLauncher

- (instancetype)initWithApplicationId:(NSString *) applicationId;
{
    self = [super init];
    if (self)
    {
        self.applicationId = applicationId;
    }
    return self;
}

-(void)launchIndividualChat:(NSString *)userId andViewControllerObject:(UIViewController *)viewController andWithText:(NSString *)text;
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Applozic"
                                bundle:[NSBundle bundleForClass:ALChatViewController.class]];
    
    ALChatViewController *chatView =(ALChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ALChatViewController"];
    chatView.contactIds = userId;
    chatView.text = text;
    chatView.individualLaunch = YES;
    chatView.titleOfView = viewController.title;
    UINavigationController *conversationViewNavController = [[UINavigationController alloc] initWithRootViewController:chatView];
    
    [viewController presentViewController:conversationViewNavController animated:YES completion:nil];
}

-(void)launchIndividualChat:(NSString *)userId withDisplayName:(NSString*)displayName
    andViewControllerObject:(UIViewController *)viewController andWithText:(NSString *)text
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Applozic" bundle:[NSBundle bundleForClass:ALChatViewController.class]];
    
    ALChatViewController *chatView = (ALChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ALChatViewController"];
    chatView.contactIds = userId;
    chatView.text = text;
    chatView.individualLaunch = YES;
    chatView.displayName = displayName;
    chatView.titleOfView = viewController.title;
    UINavigationController *conversationViewNavController = [[UINavigationController alloc] initWithRootViewController:chatView];
    [viewController presentViewController:conversationViewNavController animated:YES completion:nil];
}

-(void)launchChatList:(NSString *)title andViewControllerObject:(UIViewController *)viewController
{
    [ALApplozicSettings setTitleForBackButton:title];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Applozic" bundle:[NSBundle bundleForClass:ALChatViewController.class]];
    UIViewController *theTabBar = [storyboard instantiateViewControllerWithIdentifier:@"messageTabBar"];
    [viewController presentViewController:theTabBar animated:YES completion:nil];
}

-(void) launchChatForUser:(NSString* )userId fromViewController:(UIViewController*)viewController
{
    ALUser *user = [[ALUser alloc] init];
    [user setApplicationId:self.applicationId];
    [user setUserId:userId];
    [self startChatsForUser:user andWithParentController:(UIViewController *)viewController];
}

-(void) launchChatForUser:(NSString*)userId andWithEmailId:(NSString*)emailId fromViewController:(UIViewController*)viewController
{
    ALUser *user = [[ALUser alloc] init];
    [user setApplicationId:self.applicationId];
    [user setUserId:userId];
    [user setEmailId:emailId];
    [self  startChatsForUser:user andWithParentController:(UIViewController *)viewController];
}

-(void)startChatsForUser:(ALUser *) alUser andWithParentController:(UIViewController *)viewController
{
    if([ALUserDefaultsHandler getDeviceKeyString])
    {
        NSLog(@"user is already registered... ");
       [self launchChatList:viewController.title  andViewControllerObject:viewController];
     //[self launchIndividualChat:@"adarshk" andViewControllerObject:viewController andWithText:nil];
        return;
    }
    
    ALRegisterUserClientService *registerUserClientService = [[ALRegisterUserClientService alloc] init];
    [registerUserClientService initWithCompletion:alUser withCompletion:^(ALRegistrationResponse *rResponse, NSError *error) {
        
        if (error)
        {
            NSLog(@"%@",error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Response" message:rResponse.message
                                                               delegate: nil cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil, nil];
            [alertView show];
            return;
        }
        
        if (rResponse && [rResponse.message containsString: @"REGISTERED"])
        {
    
        }
        
        [self launchChatList:viewController.title  andViewControllerObject:viewController];
//        [self launchIndividualChat:@"adarshk" andViewControllerObject:viewController andWithText:nil];
        NSLog(@"Registration response from server:%@", rResponse);
    }];
}

-(void)registerForNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                                               UIUserNotificationTypeSound |
                                                                               UIUserNotificationTypeAlert)];
    }
}

-(void)mbChatViewSettings
{
//    //For DEVELOPMENT CERT::
//    [ALUserDefaultsHandler setDeviceApnsType:(short)DEVELOPMENT];
//    //For Distribution CERT::
//    //[ALUserDefaultsHandler setDeviceApnsType:(short)DISTRIBUTION];
    
    [ALUserDefaultsHandler setLogoutButtonHidden:YES];
    [ALUserDefaultsHandler setBottomTabBarHidden:YES];
    [ALApplozicSettings setUserProfileHidden:YES];
    [ALApplozicSettings hideRefreshButton:YES];
    [ALApplozicSettings setTitleForConversationScreen:@"My Chats"];
    [ALApplozicSettings setFontFace:@"Helvetica"];
    [ALApplozicSettings setColourForReceiveMessages:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    [ALApplozicSettings setColourForSendMessages:[UIColor colorWithRed:66.0/255 green:173.0/255 blue:247.0/255 alpha:1]];
//    [ALUserDefaultsHandler setNotificationTitle:@"MagicBricks"];
    [ALApplozicSettings setColourForNavigation:[UIColor colorWithRed:181.0/255 green:31.0/255 blue:35.0/255 alpha:1]];
    [ALApplozicSettings setColourForNavigationItem:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    
}

@end

