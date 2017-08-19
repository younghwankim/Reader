//
//  KWEWeakReference.h
//  KWEPopover
//
//  Created by KWErner Altewischer on 25/02/16.
//  Copyright © 2016 KWErner IT Consultancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWEWeakReference : NSObject

@property (nonatomic, weak) id object;

+ (instancetype)kweweakReferenceWithObject:(id)object;

@end
