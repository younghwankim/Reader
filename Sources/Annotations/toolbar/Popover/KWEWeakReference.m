//
//  WEWeakReference.m
//  WEPopover
//
//  Created by Werner Altewischer on 25/02/16.
//  Copyright © 2016 Werner IT Consultancy. All rights reserved.
//

#import "KWEWeakReference.h"

@implementation KWEWeakReference

+ (instancetype)kweweakReferenceWithObject:(id)object {
    KWEWeakReference *ref = [self new];
    ref.object = object;
    return ref;
}

@end
