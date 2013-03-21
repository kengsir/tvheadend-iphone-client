//
//  TVHSettings.h
//  TVHeadend iPhone Client
//
//  Created by zipleen on 2/9/13.
//  Copyright 2013 Luis Fernandes
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#define TVHS_SERVER_NAME @"ServerName"
#define TVHS_IP_KEY @"ServerIp"
#define TVHS_PORT_KEY @"ServerPort"
#define TVHS_USERNAME_KEY @"Username"
#define TVHS_PASSWORD_KEY @"Password"
#define TVHS_SELECTED_SERVER @"SelectedServer"
#define TVHS_SERVERS @"Servers"

#define TVHS_SERVER_KEYS @[TVHS_SERVER_NAME, TVHS_IP_KEY, TVHS_PORT_KEY, TVHS_USERNAME_KEY, TVHS_PASSWORD_KEY]

@interface TVHSettings : NSObject
+ (id)sharedInstance;
@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic) NSInteger selectedServer;
@property (nonatomic) NSTimeInterval cacheTime;

- (NSString*)serverProperty:(NSString*)key forServer:(NSInteger)serverId;
- (void)setServerProperty:(NSString*)property forServer:(NSInteger)serverId ForKey:(NSString*)key;
- (void)removeServer:(NSInteger)serverId;
- (NSString*)currentServerProperty:(NSString*)key;
- (NSArray*)availableServers;
- (NSInteger)addNewServer;
- (void)resetSettings;
@end
