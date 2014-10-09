//
//  KeyInterpreter.m
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "KeyInterpreter.h"

@implementation KeyInterpreter

+ (NSString *)getSymbolForTag:(int)tag
{
    switch (tag) {
        case LEFT:
            return @"left-button.png"; break;
        case RIGHT:
            return @"right.png"; break;
        case CLIMB:
            return @"climb.png"; break;
        case DESCEND:
            return @"descend.png"; break;
        case CROSS:
            return @"cross.png"; break;
            
        case NDB:
            return @"ndb.png"; break;
        case VOR:
            return @"vor.png"; break;
        case ILS:
            return @"ils.png"; break;
        case HOLDSHORT:
            return @"hold-short.png"; break;
        case HOLDCAT:
            return @"cat.png"; break;
            
        case CALL:
            return @"call.png"; break;
            
        case DIRECT:
            return @"direct.png"; break;
        case HOLDING:
            return @"holding.png"; break;
            
        case VECTORS:
            return @"vectors.png"; break;
        case MIN10:
            return @"10-min.png"; break;
        case SQAWK:
            return @"xpdr.png"; break;
        case INTC:
            return @"intc.png"; break;
        case RUNWAY:
            return @"rwy.png"; break;
        case BY_TIME:
            return @"by-time.png"; break;
            
        case SID:
            return @"sid.png"; break;
        case ALTIMETER:
            return @"altimeter.png"; break;
            
        case STAR:
            return @"star.png"; break;
            
        case UP:
            return @"up.png"; break;
            
        case DOWN:
            return @"down.png"; break;
            
        default:
            NSLog(@"BAD TAG"); break;
    }
    return @"not-found.png";
}
@end
