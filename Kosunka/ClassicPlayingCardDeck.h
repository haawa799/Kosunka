//
//  ClassicPlayingCardDeck.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassicPlayingCard.h"
#import "Deck.h"

@interface ClassicPlayingCardDeck : Deck

-(id)initDefault50CardDeckShuffle:(BOOL)shuffle;

@end
