//
//  ALUserDetail.h
//  Applozic
//
//  Created by devashish on 26/11/2015.
//  Copyright © 2015 applozic Inc. All rights reserved.
//

#import <CoreData/NSManagedObject.h>
#import <Foundation/Foundation.h>
#import "ALJson.h"

@interface ALUserDetail : ALJson


@property (nonatomic, strong) NSString *userId;

@property (nonatomic) BOOL connected;

@property (nonatomic, strong) NSNumber *lastSeenAtTime;

@property (nonatomic, strong) NSString *unreadCount;

@property (nonatomic, strong) NSString *displayName;

@property(nonatomic, copy) NSManagedObjectID *userDetailDBObjectId;

-(void)setUserDetails:(NSString *)jsonString;

-(void)userDetail;

-(id)initWithDictonary:(NSDictionary*)messageDictonary;

@end
