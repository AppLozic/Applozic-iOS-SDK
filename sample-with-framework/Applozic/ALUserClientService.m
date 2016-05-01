//
//  ALUserClientService.m
//  Applozic
//
//  Created by Devashish on 21/12/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALUserClientService.h"
#import <Foundation/Foundation.h>
#import "ALConstant.h"
#import "ALUserDefaultsHandler.h"
#import "ALRequestHandler.h"
#import "ALResponseHandler.h"
#import "NSString+Encode.h"


@implementation ALUserClientService

+(void)userLastSeenDetail:(NSNumber *)lastSeenAt withCompletion:(void(^)(ALLastSeenSyncFeed *))completionMark
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/status",KBASE_URL];
    if(!lastSeenAt){
        lastSeenAt = [ALUserDefaultsHandler getLastSyncTime];
        NSLog(@"lastSeenAt is coming as null seeting default vlaue to %@", lastSeenAt);
    }
    NSString * theParamString = [NSString stringWithFormat:@"lastSeenAt=%@",lastSeenAt.stringValue];
    NSLog(@"calling last seen at api for userIds: %@", theParamString);
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_LAST_SEEN_NEW" WithCompletionHandler:^(id theJson, NSError *theError) {
        if (theError)
        {
            NSLog(@"ERROR IN LAST SEEN %@", theError);
        }
        else
        {
//            NSLog(@"SEVER RESPONSE FROM JSON : %@", (NSString *)theJson);
            NSNumber * generatedAt =  [theJson  valueForKey:@"generatedAt"];
            [ALUserDefaultsHandler setLastSeenSyncTime:generatedAt];
            ALLastSeenSyncFeed  * responseFeed =  [[ALLastSeenSyncFeed alloc] initWithJSONString:(NSString*)theJson];
            
            completionMark(responseFeed);
        }
        
        
    }];
    
}

-(void)userDetailServerCall:(NSString *)contactId withCompletion:(void(^)(ALUserDetail *))completionMark
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/detail",KBASE_URL];
    NSString * theParamString = [NSString stringWithFormat:@"userIds=%@",[contactId urlEncodeUsingNSUTF8StringEncoding]];
    
    NSLog(@"calling last seen at api for userIds: %@", contactId);
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_LAST_SEEN" WithCompletionHandler:^(id theJson, NSError *theError) {
        if (theError)
        {
            NSLog(@"ERROR IN LAST SEEN %@", theError);
            completionMark(nil);
        }
        else
        {
            if(((NSArray*)theJson).count > 0)
            {
                //NSLog(@"SEVER RESPONSE FROM JSON : %@", (NSString *)theJson);
                ALUserDetail *userDetailObject = [[ALUserDetail alloc] initWithDictonary:[theJson objectAtIndex:0]];
                [userDetailObject userDetail];
                completionMark(userDetailObject);
            }
            else
            {
                completionMark(nil);
            }
        }
        
    }];
    
}

-(void)updateUserDisplayName:(ALContact *)alContact withCompletion:(void(^)(id theJson, NSError *theError))completion
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/name", KBASE_URL];
    NSString * theParamString = [NSString stringWithFormat:@"userId=%@&displayName=%@",
                                 [alContact.userId urlEncodeUsingNSUTF8StringEncoding],alContact.displayName];
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_DISPLAY_NAME_UPDATE" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        if (theError)
        {
            completion(nil,theError);
            return ;
        }
        else
        {
            NSLog(@"Response of USER_DISPLAY_NAME_UPDATE : %@", (NSString *)theJson);
            completion((NSString *)theJson, nil);
        }
        
    }];
    
}

-(void)markConversationAsReadforContact:(NSString *)contactId withCompletion:(void (^)(NSString *, NSError *))completion{
    
    
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/message/read/conversation",KBASE_URL];
    NSString * theParamString;
    theParamString = [NSString stringWithFormat:@"userId=%@",[contactId urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"MARK_CONVERSATION_AS_READ" WithCompletionHandler:^(id theJson, NSError *theError) {
        if (theError) {
            completion(nil,theError);
            NSLog(@"theError");
            return ;
        }else{
            //read sucessfull
            NSLog(@"sucessfully marked read !");
        }
        NSLog(@"Response: %@", (NSString *)theJson);
        completion((NSString *)theJson,nil);
    }];
}

//==============================================
#pragma BLOCK USER SERVER CALL
//==============================================

+(void)userBlockServerCall:(NSString *)userId withCompletion:(void (^)(NSString *json, NSError *error))completion
{    
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/block",KBASE_URL];
    NSString * theParamString;
    theParamString = [NSString stringWithFormat:@"userId=%@",[userId urlEncodeUsingNSUTF8StringEncoding]];
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_BLOCKED" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        NSLog(@"USER_BLOCKED RESPONSE JSON: %@", (NSString *)theJson);
        if (theError){
            NSLog(@"theError %@",theError);
        }
        else{
        
            completion((NSString *)theJson, nil);
        }
        
        NSLog(@"Response USER_BLOCKED:%@",theJson);
    }];
}

+(void)userBlockSyncServerCall:(NSNumber *)lastSyncTime withCompletion:(void (^)(NSString *json, NSError *error))completion
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/blocked/sync",KBASE_URL];
    NSString * theParamString;
    theParamString = [NSString stringWithFormat:@"lastSyncTime=%@",lastSyncTime];
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_BLOCK_SYNC" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        NSLog(@"USER_BLOCKED SYNC RESPONSE JSON: %@", (NSString *)theJson);
        if (theError)
        {
            NSLog(@"theError");
        }
        else
        {
            completion((NSString *)theJson, nil);
        }
        
    }];
}

//==============================================
#pragma UNBLOCK USER SERVER CALL
//==============================================

+(void)userUnblockServerCall:(NSString *)userId withCompletion:(void (^)(NSString *json, NSError *error))completion
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/unblock",KBASE_URL];
    NSString * theParamString;
    theParamString = [NSString stringWithFormat:@"userId=%@",[userId urlEncodeUsingNSUTF8StringEncoding]];
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"USER_UNBLOCKED" WithCompletionHandler:^(id theJson, NSError *theError) {
        
        NSLog(@"USER_UNBLOCKED RESPONSE JSON: %@", (NSString *)theJson);
        if (theError)
        {
            NSLog(@"theError,%@",theError);
        }
        else{
            completion((NSString *)theJson, nil);
        }
        NSLog(@"Response USER_UNBLOCKED:%@",(NSString *)theJson);
    }];
}

#pragma mark - Mark Message Read
//==============================

-(void)markMessageAsReadforPairedMessageKey:(NSString *)pairedMessageKey withCompletion:(void (^)(NSString *, NSError *))completion{
    
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/message/read",KBASE_URL];
    NSString * theParamString;
    theParamString = [NSString stringWithFormat:@"key=%@",pairedMessageKey];
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"MARK_MESSAGE_AS_READ" WithCompletionHandler:^(id theJson, NSError *theError) {
        if (theError) {
            completion(nil,theError);
            NSLog(@"theError");
            return ;
        }
        NSLog(@"markMessageAsRead %@",theJson);
        completion((NSString *)theJson,nil);
    }];
}

#pragma mark - Multi User Send Message
//===================================

+(void)multiUserSendMessage:(NSDictionary *)messageDictionary
                 toContacts:(NSMutableArray*)contactIdsArray
                   toGroups:(NSMutableArray*)channelKeysArray
             withCompletion:(void (^)(NSString *json, NSError *error))completion{
    
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/message/sendall",KBASE_URL];
    
    NSMutableDictionary *channelDictionary = [NSMutableDictionary new];
    [channelDictionary setObject:contactIdsArray forKey:@"userNames"];
    [channelDictionary setObject:channelKeysArray forKey:@"groupIds"];
    [channelDictionary setObject:messageDictionary forKey:@"messageObject"];
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:channelDictionary options:0 error:&error];
    NSString *theParamString = [[NSString alloc] initWithData:postdata encoding: NSUTF8StringEncoding];
    NSMutableURLRequest * theRequest = [ALRequestHandler createPOSTRequestWithUrlString:theUrlString paramString:theParamString];
    
    [ALResponseHandler processRequest:theRequest andTag:@"MULTI_USER_SEND" WithCompletionHandler:^(id theJson, NSError *theError) {
        completion(theJson,theError);
        
    }];
}

-(void)getListOfRegisteredUsers:(NSNumber *)startTime andPageSize:(NSUInteger)pageSize withCompletion:(void(^)(ALContactsResponse * response, NSError * error))completion
{
    NSString * theUrlString = [NSString stringWithFormat:@"%@/rest/ws/user/filter",KBASE_URL];
    NSString * pageSizeString = [NSString stringWithFormat:@"%lu", (unsigned long)pageSize];
    
    NSString * theParamString = @"";
    theParamString = [NSString stringWithFormat:@"pageSize=%@", pageSizeString];
    if(startTime)
    {
        theParamString = [NSString stringWithFormat:@"pageSize=%@&startTime=%@", pageSizeString, startTime];
    }
    
    NSMutableURLRequest * theRequest = [ALRequestHandler createGETRequestWithUrlString:theUrlString paramString:theParamString];
    [ALResponseHandler processRequest:theRequest andTag:@"FETCH_CONTACT_WITH_PAGE_SIZE" WithCompletionHandler:^(id theJson, NSError * theError) {
        
        if (theError)
        {
            completion(nil, theError);
            NSLog(@"ERROR_IN_FETCH_CONTACT_WITH_PAGE_SIZE : %@", theError);
            return ;
        }
        
        NSLog(@"RESPONSE_FETCH_CONTACT_WITH_PAGE_SIZE_JSON %@",theJson);
        ALContactsResponse * contactResponse = [[ALContactsResponse alloc] initWithJSONString:(NSString *)theJson];
        completion(contactResponse, nil);
        [ALUserDefaultsHandler setContactViewLoadStatus:YES];
    }];
}

@end
