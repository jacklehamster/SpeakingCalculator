//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Vincent Le Quang on 8/16/13.
//  Copyright (c) 2013 Vincent Le Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject {
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    NSMutableArray *operations;
}

- (NSString*) processSpeech:(NSString*)operation;
- (NSString*) operations;
- (void)setOperand:(double)anOperand;
- (double)performOperation:(NSString*) operation;

@end
