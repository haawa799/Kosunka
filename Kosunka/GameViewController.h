//
//  GameViewController.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"
#import "Game.h"
#import "ColumnsOfCards.h"
#import "SuitPitView.h"

@interface GameViewController : UIViewController<ColumnOfCardsDraggingProtocol,SuitPitDraggAndDropProtocol>

@property (strong,nonatomic) Game *game;

@property (weak, nonatomic) IBOutlet PlayingCardView *deckCardView;

@property (weak, nonatomic) IBOutlet PlayingCardView *currentCardFromDeck;

@property (strong, nonatomic) IBOutletCollection(SuitPitView) NSArray *suitPits;

- (IBAction)deckCardViewTapped:(UITapGestureRecognizer *)sender;

- (IBAction)currentCardFromDeckTaped:(UIPanGestureRecognizer *)sender;

@end
