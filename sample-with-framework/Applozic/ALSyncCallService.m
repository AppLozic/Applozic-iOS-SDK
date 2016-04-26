//
//  ALSyncCallService.m
//  Applozic
//
//  Created by Applozic Inc on 12/14/15.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import "ALSyncCallService.h"
#import "ALMessageDBService.h"
#import "ALContactDBService.h"
#import "ALChannelService.h"

@implementation ALSyncCallService


-(void) updateMessageDeliveryReport:(NSString *)messageKey withStatus:(int)status{
    ALMessageDBService *alMessageDBService = [[ALMessageDBService alloc] init];
    [alMessageDBService updateMessageDeliveryReport:messageKey withStatus:status];
}

-(void) updateDeliveryStatusForContact:(NSString *)contactId withStatus:(int)status {
    ALMessageDBService* messageDBService = [[ALMessageDBService alloc] init];
    [messageDBService updateDeliveryReportForContact:contactId withStatus:status];
}

-(void) syncCall: (ALMessage *) alMessage {
    
    if (alMessage.groupId != nil && alMessage.contentType == 10) {
        ALChannelService *channelService = [[ALChannelService alloc] init];
        [channelService syncCallForChannel];
    }
}

-(void) updateConnectedStatus: (ALUserDetail *) alUserDetail {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userUpdate" object:alUserDetail];
    ALContactDBService* contactDBService = [[ALContactDBService alloc] init];
    [contactDBService updateLastSeenDBUpdate:alUserDetail];
}

@end
