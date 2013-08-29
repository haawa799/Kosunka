//
//  Deck.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef enum{
    TOP = -1,BOT= -2,RANDOM = -3
}IN_DECK_POSITION;

@interface Deck : NSObject

@property (strong,nonatomic) NSMutableArray *cardsArray;

//inserts card into current deck on desired position
-(void)addCard:(Card *)card atPosition:(IN_DECK_POSITION)position;

//draws and returns card from (random position/top/bot); if putBack == NO then card is removed from deck
-(Card *)drawCardFrom:(IN_DECK_POSITION)position putBack:(BOOL)putBack;

-(Card *)drawCardFromTopAndPutOnBot;

//returns deck that hold number of cards from DECK(self); if if putBack == NO then cards are removed from DECK(self)
-(Deck *)subDeckWithNumberOfCards:(NSInteger)number putBack:(BOOL)putBack;

@end
