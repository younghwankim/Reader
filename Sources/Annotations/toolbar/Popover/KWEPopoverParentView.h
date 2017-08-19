/*
 *  KWEPopoverParentView.h
 *  KWEPopover
 *
 *  Created by KWErner Altewischer on 02/09/10.
 *  Copyright 2010 KWErner IT Consultancy. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KWEPopoverParentView

@optional
- (CGRect)displayAreaForPopover;

@end
