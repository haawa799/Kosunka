//
//  ClassicPlayingCardDeck.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "ClassicPlayingCardDeck.h"

@implementation ClassicPlayingCardDeck

-(id)init
{
    self = [super init];
    if(self)
    {
        //
    }
    return self;
}

-(id)initDefault50CardDeckShuffle:(BOOL)shuffle
{
    self = [self init];
    if(self)
    {
        for(NSString *suit in [ClassicPlayingCard validSuits])
        {
            for(NSInteger rank = 1; rank <= [ClassicPlayingCard maxRank];rank++)
            {
                ClassicPlayingCard *card = [[ClassicPlayingCard alloc]init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card atPosition:shuffle?RANDOM:TOP];
            }
        }
    }
    return self;
}

@end
