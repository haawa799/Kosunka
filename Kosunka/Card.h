//
//  Card.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic,getter = isFaceUp) BOOL faceUp;
@property (nonatomic,getter = isUnplayable) BOOL unplayable;

@property (strong,nonatomic) NSString *contents;

@end
