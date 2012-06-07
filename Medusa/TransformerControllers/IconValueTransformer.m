//
//  IconValueTransformer.m
//  Medusa
//
//  Created by Giancarlo Mariot on 13/04/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//
//------------------------------------------------------------------------------
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//------------------------------------------------------------------------------

#import "IconValueTransformer.h"

@implementation IconValueTransformer

+ (Class)transformedValueClass {
    return [NSImage class]; 
}
+ (BOOL)allowsReverseTransformation { 
    return NO; 
}

- (id)transformedValue:(id)value {
	
	NSInteger _icon = [value intValue];
    //NSLog(@"%ld", _icon);
    
    switch (_icon) {
        default:
        case 1:
//            return [NSImage imageNamed:@"GenericQuestionMarkIcon.icns"];
//            break;
            
        case 2:
            return [NSImage imageNamed:@"FinderGrey.icns"];
            break;
            
        case 3:
            return [NSImage imageNamed:@"FinderBlue.icns"];
            break;
    }
	
	return [NSImage imageNamed:@"GenericQuestionMarkIcon.icns"];
}

@end
