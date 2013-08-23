//
//  CalculatorViewController.h
//  SpeakingCalculator
//
//  Created by Vincent Le Quang on 8/19/13.
//  Copyright (c) 2013 Jack Le Hamster. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@class FliteTTS;

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController {
    IBOutlet UILabel *display;
    IBOutlet UILabel *operationsDisplay;
    IBOutlet UIImageView *image;
    CalculatorBrain *brain;
    BOOL numberEntered;
    
    double pitch, variance, speed;
    
    FliteTTS *fliteEngine;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@end
