//
//  ClassicPlaymingCard.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef enum{
    INVALID_COLOR = -1,
    RED,BLACK
}CARD_COLOR;

@interface ClassicPlayingCard: Card

@property (strong,nonatomic) NSString *suit;
@property (nonatomic) NSInteger rank;

//+(CARD_COLOR)cardColorForSuit:(NSString *)suit;

+(BOOL)counterColorsForSuit1:(NSString *)suit1 suit2:(NSString *)suit2;

+(NSArray *)validSuits;

+(NSInteger)maxRank;

-(BOOL)hasRankLowerBy:(NSInteger)dRank then:(ClassicPlayingCard *)otherCard;

@end
