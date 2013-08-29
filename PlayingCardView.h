//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Andrew Kharchyshyn on 4/30/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong,nonatomic) NSString *suit;

@property (nonatomic,getter = isFaceUp) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
