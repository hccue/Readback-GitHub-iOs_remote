//
//  KeyInterpreter.h
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NO_TAG      0
#define LEFT        1
#define RIGHT       2
#define CLIMB       3
#define DESCEND     4
#define CROSS       5
#define DELETE      6

#define NDB         8
#define VOR         13
#define ILS         12
#define HOLDSHORT   9
#define HOLDCAT     10

#define SPACE       11
#define CALL        14

#define DIRECT      15
#define HOLDING     16

@interface KeyInterpreter : NSObject
+ (NSString *)getSymbolForTag:(int)tag;
@end

