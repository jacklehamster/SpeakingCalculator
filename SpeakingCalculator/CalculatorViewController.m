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
    // Load images
    NSArray *imageNames = @[@"talk0001.png",@"talk0002.png",@"talk0003.png",@"talk0004.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    image.animationImages = images;
    image.animationDuration = 0.2;
    
    pitch = 140.0+arc4random()%20;
    variance = 45.0+arc4random()%10;
    speed = 0.8;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    [fliteEngine setPitch:pitch variance:variance speed:speed];	// Change the voice properties
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
        image.animationRepeatCount = 2*[[display text] length];
        [image startAnimating];
    }
    else {
        [display setText:digit];
        numberEntered = YES;
        [[self brain] setOperand:0];
        [[self brain] performOperation:@""];
        [fliteEngine stopTalking];
        [fliteEngine speakText:[[self brain] processSpeech:digit]];	// Make it talk
        image.animationRepeatCount = 2;
        [image startAnimating];
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
    image.animationRepeatCount = [speak length]*.8;
    [image startAnimating];
}

@end

