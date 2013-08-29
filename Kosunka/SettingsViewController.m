//
//  SettingsViewController.m
//  Kosunka
//
//  Created by Andrew Kharchyshyn on 5/3/13.
//  Copyright (c) 2013 kharchyshyn.andrew. All rights reserved.
//

#import "SettingsViewController.h"
#import "Auxility.h"


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeSegmentedControl;
@property (nonatomic,getter = isThreeCardMode) BOOL threeCardMode;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.threeCardMode = [Auxility isThreeCardMode];
    [self.cardModeSegmentedControl setSelectedSegmentIndex:self.isThreeCardMode];
}


- (IBAction)segmentedControlChangedValue
{
    [Auxility setThreeCardMode:!self.isThreeCardMode];
}


@end
