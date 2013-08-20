//
//  CalculatorAppDelegate.h
//  SpeakingCalculator
//
//  Created by Vincent Le Quang on 8/19/13.
//  Copyright (c) 2013 Jack Le Hamster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorViewController;

@interface CalculatorAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CalculatorViewController *viewController;

@end
