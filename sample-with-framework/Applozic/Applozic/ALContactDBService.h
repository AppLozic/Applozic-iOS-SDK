//
//  ALContactDBService.h
//  ChatApp
//
//  Created by Devashish on 23/10/15.
//  Copyright © 2015 AppLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALContact.h"
#import "DB_CONTACT.h"
#import "ALUserDetail.h"

@interface ALContactDBService : NSObject

-(BOOL)purgeListOfContacts:(NSArray *)contacts;

-(BOOL)purgeContact:(ALContact *)contact;

-(BOOL)purgeAllContact;

-(BOOL)updateListOfContacts:(NSArray *)contacts;

-(BOOL)updateConatct:(ALContact *)contact;

-(BOOL)addListOfContacts:(NSArray *)contacts;

-(BOOL)addContact:(ALContact *)userContact;

-(void) updateConnectedStatus: (NSString *) userId lastSeenAt:(NSNumber *) lastSeenAt  connected: (BOOL) connected;

- (DB_CONTACT *)getContactByKey:(NSString *) key value:(NSString*) value;

- (ALContact *)loadContactByKey:(NSString *) key value:(NSString*) value;

-(void)addUserDetails:(NSMutableArray *)userDetails;

-(DB_CONTACT*) createUserDetailEntityForDBInsertionWithUserDetail:(ALUserDetail *) userDetail;

-(BOOL)updateUserDetail:(ALUserDetail *)userDetail;

@end
