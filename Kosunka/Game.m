//
//  Game.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "Game.h"
#import "Auxility.h"

#define NUMBER_OF_COLUMNS 7

@interface Game()

@property (strong,nonatomic) ClassicPlayingCardDeck *startDeck;

@end

@implementation Game

#pragma mark Setters & Getters

-(ClassicPlayingCardDeck *)startDeck
{
    if(!_startDeck)
        _startDeck = [[ClassicPlayingCardDeck alloc]initDefault50CardDeckShuffle:YES];
    return _startDeck;
}

-(ClassicPlayingCardDeck *)mainDeck
{
    if(!_mainDeck)
    {
        _mainDeck = (ClassicPlayingCardDeck *)[self.startDeck subDeckWithNumberOfCards:[self numberOfCardsInMainDeck] putBack:NO];
    }
    return _mainDeck;
}

-(NSMutableArray *)arrayOfSubDecks
{
    if(!_arrayOfSubDecks)
    {
        _arrayOfSubDecks = [[NSMutableArray alloc]initWithCapacity:NUMBER_OF_COLUMNS];
        
        for(NSInteger i = 0;i<NUMBER_OF_COLUMNS;i++)
        {
            //number of cards in each column
            NSInteger numberOfCards = i+1;
            ClassicPlayingCardDeck *subDeckForColumn = (ClassicPlayingCardDeck *)[self.startDeck subDeckWithNumberOfCards:numberOfCards putBack:NO];
            
            [_arrayOfSubDecks insertObject:subDeckForColumn atIndex:i];
        }
    }
    return _arrayOfSubDecks;
}

-(NSMutableDictionary *)dictOfSuitedSubDecks
{
    if(!_dictOfSuitedSubDecks)
    {
        _dictOfSuitedSubDecks = [[NSMutableDictionary alloc]initWithCapacity:[[ClassicPlayingCard validSuits] count]];
        
    }
    return _dictOfSuitedSubDecks;
}

-(BOOL)isThreeCardMode
{
    return [Auxility isThreeCardMode];
}

#pragma mark Other methods

-(NSInteger)numberOfCardsInMainDeck
{
    NSInteger count = 0;
    for (NSInteger i = 0;i<=NUMBER_OF_COLUMNS;i++) {
        count += i;
    }
    return 52-count;
}

@end
