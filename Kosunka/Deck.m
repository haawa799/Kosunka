//
//  Deck.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@end

@implementation Deck

#pragma mark Getters & Setters

-(NSMutableArray *)cardsArray
{
    if(!_cardsArray)
    {
        _cardsArray = [[NSMutableArray alloc]init];
    }
    return _cardsArray;
}

-(NSInteger)positionFor:(IN_DECK_POSITION)position
{
    NSInteger pos = -1;
    switch (position) {
        case TOP:
            pos = 0;
            break;
        case BOT:
            pos = [self.cardsArray count];
            break;
        case RANDOM:
            if([self.cardsArray count])
                pos = arc4random()%[self.cardsArray count];
            else
                pos = 0;
            break;
        default:
            pos = position;
            break;
    }
    return pos;
}

-(void)addCard:(Card *)card atPosition:(IN_DECK_POSITION)position
{
    NSInteger pos = [self positionFor:position];
    [self.cardsArray insertObject:card atIndex:pos];
}

-(Card *)drawCardFrom:(IN_DECK_POSITION)position putBack:(BOOL)putBack
{
    if([self.cardsArray count])
    {
        NSInteger pos = [self positionFor:position];
        Card *returnedCard = self.cardsArray[pos];
        if(!putBack)
            [self.cardsArray removeObjectAtIndex:pos];
        return returnedCard;
    }else
        return nil;
}

-(Card *)drawCardFromTopAndPutOnBot
{
    if([self.cardsArray count])
    {
        NSInteger pos = [self positionFor:TOP];
        Card *returnedCard = self.cardsArray[pos];
        [self.cardsArray removeObjectAtIndex:pos];
        [self.cardsArray insertObject:returnedCard atIndex:[self positionFor:BOT]];
        return returnedCard;
    }else
        return nil;
}

-(Deck *)subDeckWithNumberOfCards:(NSInteger)number putBack:(BOOL)putBack
{
    NSLog(@"CARDS LEFT : %i",[self.cardsArray count]);
    //NSAssert(number<=[self.cardsArray count], @"Requested number of cards is higher then number of all cards in deck");
    Deck *deck = [[Deck alloc]init];
    for(int i = 0;i<number;i++)
        [deck addCard:[self drawCardFrom:RANDOM putBack:putBack] atPosition:TOP];
    return deck;
}


@end
