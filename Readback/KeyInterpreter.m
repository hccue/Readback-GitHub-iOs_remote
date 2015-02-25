//
//  KeyInterpreter.m
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "KeyInterpreter.h"

@implementation KeyInterpreter

+ (NSString *)getSymbolForTag:(int)tag isDaySymbol:(BOOL)isDaySymbol
{
    NSString *symbolName;
    switch (tag) {
        case LEFT:
            symbolName = @"left-button"; break;
        case RIGHT:
            symbolName = @"right"; break;
        case CLIMB:
            symbolName = @"climb"; break;
        case DESCEND:
            symbolName = @"descend"; break;
        case CROSS:
            symbolName = @"cross"; break;
        case NDB:
            symbolName = @"ndb"; break;
        case VOR:
            symbolName = @"vor"; break;
        case ILS:
            symbolName = @"ils"; break;
        case HOLDSHORT:
            symbolName = @"hold-short"; break;
        case HOLDCAT:
            symbolName = @"cat"; break;
        case CALL:
            symbolName = @"call"; break;
        case DIRECT:
            symbolName = @"direct"; break;
        case HOLDING:
            symbolName = @"holding"; break;
        case VECTORS:
            symbolName = @"vectors"; break;
        case MIN10:
            symbolName = @"10-min"; break;
        case SQAWK:
            symbolName = @"xpdr"; break;
        case INTC:
            symbolName = @"intc"; break;
        case RUNWAY:
            symbolName = @"rwy"; break;
        case BY_TIME:
            symbolName = @"by-time"; break;
        case SID:
            symbolName = @"sid"; break;
        case ALTIMETER:
            symbolName = @"altimeter"; break;
        case STAR:
            symbolName = @"star"; break;
        case UP:
            symbolName = @"up"; break;
        case DOWN:
            symbolName = @"down"; break;
            default:
            symbolName = @"not-found"; break;
    }
    
    if (isDaySymbol) {
        symbolName = [symbolName stringByAppendingString:@"-d.png"];
    }else{
        symbolName = [symbolName stringByAppendingString:@".png"];
    }
    return symbolName;
}
@end
