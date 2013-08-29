//
//  SuitPitView.h
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/9/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "PlayingCardView.h"
#import "ColumnsOfCards.h"

@class ColumnsOfCards;

@protocol SuitPitDraggAndDropProtocol <NSObject>

-(ColumnsOfCards *)columnOnWhichCardFromSUitPitDropped:(PlayingCardView *)card;

-(void)fullPit;

@end

@interface SuitPitView : PlayingCardView

@property (nonatomic) BOOL full;

@property (nonatomic,weak) id<SuitPitDraggAndDropProtocol> delegate;

-(BOOL)addCard:(PlayingCardView *)card;

@end
