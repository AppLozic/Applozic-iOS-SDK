//
//  DemoChatManager.h
//  applozicdemo
//
//  Created by Devashish on 28/12/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Applozic/ALChatLauncher.h>
#import <Applozic/ALUser.h>

#define APPLICATION_ID @"applozic-sample-app"

@interface DemoChatManager : NSObject

@property(nonatomic, strong) ALChatLauncher * chatLauncher;

-(void)registerUser:(ALUser *)alUser;

@property(nonatomic,retain) NSString * userID;

-(void)launchChat: (UIViewController *)fromViewController;

-(void)launchChatForUserWithDefaultText:(NSString * )userId andFromViewController:(UIViewController*)viewController;

-(void)registerUserAndLaunchChat:(ALUser *)alUser andFromController:(UIViewController*)viewController forUser:(NSString*)userId;

-(void)launchChatForUserWithDisplayName:(NSString * )userId andwithDisplayName:(NSString*)displayName andFromViewController:(UIViewController*)fromViewController;

@end
