//
//  ALSyncMessageFeed.h
//  ChatApp
//
//  Created by Devashish on 20/09/15.
//  Copyright © 2015 AppLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALJson.h"

@interface ALSyncMessageFeed : ALJson

@property(nonatomic,copy) NSString *lastSyncTime;

@property(nonatomic,copy) NSString *currentSyncTime;

@property(nonatomic) NSArray * messagesList;

@property(nonatomic, assign) BOOL sent;

@property(nonatomic, assign) BOOL isRegisterdIdInvalid;

- (id)init:(NSString *)syncMessageResponse;



@end
