//
//  Auxility.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "Auxility.h"

@implementation Auxility

#define kCardModeKey @"Card Mode"

+(BOOL)isThreeCardMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kCardModeKey];
}

+(void)setThreeCardMode:(BOOL)mode
{
    [[NSUserDefaults standardUserDefaults] setBool:mode forKey:kCardModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
