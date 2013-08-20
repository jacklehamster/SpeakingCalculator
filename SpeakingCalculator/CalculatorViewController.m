//
//  CalculatorViewController.m
//  SpeakingCalculator
//
//  Created by Vincent Le Quang on 8/19/13.
//  Copyright (c) 2013 Jack Le Hamster. All rights reserved.
//

#import "FliteTTS.h"
#import "CalculatorViewController.h"
#import <AudioToolbox/AudioServices.h>

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
    if (!brain) {
        brain = [[CalculatorBrain alloc] init];
    }
    return brain;
}

- (void)viewDidLoad
{
    [operationsDisplay setText:@""];
    fliteEngine = [[FliteTTS alloc] init];
}

- (IBAction)buttonHover:(UIButton *)sender
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [fliteEngine setPitch:150.0 variance:50.0 speed:0.8];	// Change the voice properties
    [fliteEngine setVoice:@"cmu_us_kal16"];	// Switch to a different voice
    
    [fliteEngine speakText:[[self brain] processSpeech:[[sender titleLabel] text]]];	// Make it talk
    
}

- (IBAction)digitPressed:(UIButton *)sender
{
    [fliteEngine setPitch:150.0 variance:50.0 speed:0.8];	// Change the voice properties
    [fliteEngine setVoice:@"cmu_us_kal"];	// Switch to a different voice
    
    NSString * digit = [[sender titleLabel] text];
    if([@"." isEqual:digit]) {
        if([[display text] rangeOfString:@"."].location!=NSNotFound) {
            return;
        }
        if(!numberEntered) {
            digit = @"0.";
        }
    }
    if(numberEntered) {
        [display setText:[[display text] stringByAppendingString:digit]];
        [fliteEngine stopTalking];
        [fliteEngine speakText:[[self brain] processSpeech:[display text]]];	// Make it talk
    }
    else {
        [display setText:digit];
        numberEntered = YES;
        [[self brain] performOperation:@""];
        [fliteEngine stopTalking];
        [fliteEngine speakText:[[self brain] processSpeech:digit]];	// Make it talk
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    [fliteEngine setPitch:150.0 variance:50.0 speed:0.8];	// Change the voice properties
    [fliteEngine setVoice:@"cmu_us_kal"];	// Switch to a different voice
    
    if( numberEntered) {
        [[self brain] setOperand:[[display text] doubleValue]];
        numberEntered = NO;
    }
    NSString *operation = [[sender titleLabel] text];
    double result = [[self brain] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g", result]];
    [operationsDisplay setText:[[self brain] operations]];
    
    
    NSString* speak = [[self brain] processSpeech:operation];
    [fliteEngine stopTalking];
    [fliteEngine speakText:speak];	// Make it talk
}

@end

