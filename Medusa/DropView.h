//
//  DropView.h
//  DragDropApp
//
//  Created by Giancarlo Mariot on 28/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DropView : NSImageView {
    NSMutableArray  *acceptedTypes;
    NSString        *computerModel;
}

@property (copy) NSString *computerModel;
@property (copy) NSMutableArray *acceptedTypes;

@end

