//
//  ClassicPlaymingCard.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "ClassicPlayingCard.h"

@implementation ClassicPlayingCard

@synthesize suit = _suit;

#pragma mark Getters and Setters

-(NSString *)suit
{
    return _suit?_suit:@"?";
}

-(void)setSuit:(NSString *)suit
{
    if([[ClassicPlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

-(void)setRank:(NSInteger)rank
{
    if(rank<=[ClassicPlayingCard maxRank])
        _rank = rank;
}

-(NSString *)contents
{
    NSArray *rankStrings = [ClassicPlayingCard rankStrings];
    NSString *contents = rankStrings[self.rank];
    contents = [NSString stringWithFormat:@"%@%@",contents,self.suit];
    return contents;
}

#pragma mark Class methods

+(BOOL)counterColorsForSuit1:(NSString *)suit1
                       suit2:(NSString *)suit2
{
    CARD_COLOR color1 = [ClassicPlayingCard cardColorForSuit:suit1];
    CARD_COLOR color2 = [ClassicPlayingCard cardColorForSuit:suit2];
    
    if( (color1!=-1) && (color2!=-1) && (color1!=color2))
    {
        return YES;
    }
    return NO;
}

+(CARD_COLOR)cardColorForSuit:(NSString *)suit
{
    CARD_COLOR color = INVALID_COLOR;
    if([suit isEqualToString:@"♠"]||[suit isEqualToString:@"♣"])
    {
        color = BLACK;
    } else if ([suit isEqualToString:@"♥"]||[suit isEqualToString:@"♦"])
    {
        color = RED;
    }
    return color;
}

+(NSArray *)validSuits
{
    return @[@"♠",@"♣",@"♥",@"♦"];
}

+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSInteger)maxRank
{
    return [[ClassicPlayingCard rankStrings]count]-1;
}

#pragma mark Instance methods

-(BOOL)hasRankLowerBy:(NSInteger)dRank
                 then:(ClassicPlayingCard *)otherCard
{
    if((!self.isUnplayable)&&(!otherCard.isUnplayable))
        if((self.isFaceUp)&&(otherCard.isFaceUp))
            if((otherCard.rank - self.rank)==dRank)
                return YES;
    return NO;
}

@end
