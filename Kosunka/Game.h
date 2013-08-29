//
//  Game.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassicPlayingCardDeck.h"

@interface Game : NSObject

@property (nonatomic,getter = isThreeCardMode) BOOL threeCardMode;

//main sub deck from which player can draw cards
@property (strong,nonatomic) ClassicPlayingCardDeck *mainDeck;

//array of sub decks (7 so far)
@property (strong,nonatomic) NSMutableArray *arrayOfSubDecks;

//dictionary with keys - suits, and values - subdecks of sorted cards of one suit
@property (strong,nonatomic) NSMutableDictionary *dictOfSuitedSubDecks; 

@end
