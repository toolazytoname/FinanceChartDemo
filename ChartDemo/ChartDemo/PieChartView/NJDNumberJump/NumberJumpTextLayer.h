//
//  NumberJump.h
//  BZNumberJumpDemo
//
//  Created by SINA on 14-9-18.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NJDBezierCurve.h"

@interface NumberJumpTextLayer : CATextLayer
- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber;

- (void)jumpNumber;
@end
