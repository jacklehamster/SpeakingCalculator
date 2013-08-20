//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Vincent Le Quang on 8/16/13.
//  Copyright (c) 2013 Vincent Le Quang. All rights reserved.
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

- (id) init
{
    self = [super init];
    operations = [NSMutableArray array];
    return self;
}


- (void)setOperand:(double)anOperand
{
    operand = anOperand;
}


- (void)setWaitingOperation:(NSString*) operation
{
    waitingOperation = operation;
    
}

- (NSString*) operations
{
    return [operations componentsJoinedByString:@" "];
}

- (NSString*) processSpeech:(NSString*)operation
{
    NSString* speak = operation;
    if([operation isEqual:@"+"]) {
        speak = @"plus";
    }
    else if([operation isEqual:@"-"]) {
        speak = @"minus";
    }
    else if([operation isEqual:@"x"]) {
        speak = @"times";
    }
    else if([operation isEqual:@"/"]) {
        speak = @"divide by";
    }
    else if([operation isEqual:@"="] || [operation isEqual:@"√"] || [operation isEqual:@"cos"] || [operation isEqual:@"sin"]
            || ([operation isEqual:@"π"] && [operations count]!=2))
    {
        NSMutableArray* array = [NSMutableArray array];
        for(NSString* op in operations) {
            if([op isEqual:@"="]) {
                [array addObject:@"equals,"];
            }
            else if([op isEqual:@"π"]) {
                [array addObject:@"pie"];
            }
            else if([op isEqual:@"√"]) {
                [array addObject:@"square root"];
            }
            else if([op isEqual:@"cos"]) {
                [array addObject:@"cosign"];
            }
            else if([op isEqual:@"sin"]) {
                [array addObject:@"sine"];
            }
            else {
                [array addObject:[self processSpeech:op]];
            }
        }
        [array addObject:[NSString stringWithFormat:@"%g",operand]];
        
        speak = [array componentsJoinedByString:@" "];
    }
    else if([[operation substringToIndex:1] isEqual:@"√"]) {
        speak = [@"square root of " stringByAppendingString:[self processSpeech:[operation substringFromIndex:1]]];
    }
    else if([operation isEqual:@"C"]) {
        speak = @"clear";
    }
    else if([operation isEqual:@"0"]) {
        speak = @"zero";
    }
    else if([operation isEqual:@"1"]) {
        speak = @"one";
    }
    else if([operation isEqual:@"2"]) {
        speak = @"two";
    }
    else if([operation isEqual:@"3"]) {
        speak = @"three";
    }
    else if([operation isEqual:@"4"]) {
        speak = @"four";
    }
    else if([operation isEqual:@"5"]) {
        speak = @"five";
    }
    else if([operation isEqual:@"6"]) {
        speak = @"six";
    }
    else if([operation isEqual:@"7"]) {
        speak = @"seven";
    }
    else if([operation isEqual:@"8"]) {
        speak = @"eight";
    }
    else if([operation isEqual:@"9"]) {
        speak = @"nine";
    }
    else if([operation isEqual:@"°"]) {
        speak = @"degree";
    }
    else if(operation.length==2 && [operation characterAtIndex:1] == '.') {
        speak = [NSString stringWithFormat:@"%C point",[operation characterAtIndex:0]];
    }
    else if([operation isEqual:@"π"]) {
        speak = [NSString stringWithFormat:@"pie equals 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482331174502841027019385211055596446229, 4, 8, 9, 5, 4, 9, 3, 0, 3, 8, 1, 9, 6, 4, 42, hum, ok, i can't remember any more digits of pie."];
    }
    return speak;
}

- (void)performWaitingOperation
{
    if ([@"+" isEqual:waitingOperation]) {
        operand = waitingOperand + operand;
    }
    else if([@"-" isEqual:waitingOperation]) {
        operand = waitingOperand - operand;
    }
    else if([@"x" isEqual:waitingOperation]) {
        operand = waitingOperand * operand;
    }
    else if([@"/" isEqual:waitingOperation]) {
        if (operand) {
            operand = waitingOperand / operand;
        }
    }
}

- (double)performOperation:(NSString*) operation
{
    if([operation isEqual:@"="] && [operations containsObject:@"="]) {
        return operand;
    }
    if([operations containsObject:@"="]) {
        operations = [NSMutableArray array];
    }
    if([operation isEqual:@"√"]) {
        if(operand>0) {
            [operations addObject:[NSString stringWithFormat:@"√%g", operand]];
            [operations addObject:@"="];
            operand = sqrt(operand);
            [self performWaitingOperation];
        }
    } else if([operation isEqual:@"sin"]) {
        [operations addObject: @"sin"];
        [operations addObject: [NSString stringWithFormat:@"%g",operand]];
        [operations addObject: @"°"];
        [operations addObject:@"="];
        operand = sin(operand * M_PI/180);
        [self performWaitingOperation];
    } else if([operation isEqual:@"cos"]) {
        [operations addObject: @"cos"];
        [operations addObject: [NSString stringWithFormat:@"%g",operand]];
        [operations addObject: @"°"];
        [operations addObject:@"="];
        operand = cos(operand * M_PI/180);
        [self performWaitingOperation];
    } else if([operation isEqual:@"π"]) {
        [operations addObject:@"π"];
        [operations addObject:@"="];
        operand = M_PI;
        [self performWaitingOperation];
    } else if([operation isEqual:@"C"]) {
        operand = 0;
        [self setWaitingOperation:nil];
        waitingOperand = 0;
        operations = [NSMutableArray array];
    } else if(![operation isEqual:@""]) {
        [operations addObject: [NSString stringWithFormat:@"%g",operand]];
        [operations addObject: operation];
        [self performWaitingOperation];
        [self setWaitingOperation:operation];
        waitingOperand = operand;
    }
    return operand;
}

@end
