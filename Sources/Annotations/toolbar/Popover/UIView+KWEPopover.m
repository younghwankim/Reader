//
// Created by Werner Altewischer on 07/09/16.
// Copyright (c) 2016 Werner IT Consultancy. All rights reserved.
//

#import "UIView+KWEPopover.h"
#import <objc/runtime.h>

@implementation UIView (KWEPopover)

static IMP originalLayoutSubviewsImp = NULL;
NSString * const KWEViewDidLayoutSubviewsNotification = @"KWEViewDidLayoutSubviewsNotification";

static void __UIViewLayoutSubviews(id self, SEL _cmd) {
    ((void(*)(id,SEL))originalLayoutSubviewsImp)(self, _cmd);
    [[NSNotificationCenter defaultCenter] postNotificationName:KWEViewDidLayoutSubviewsNotification object:self];
}

+ (void)load {
    [self swizzleLayoutSubviewsMethod];
}

+ (void)swizzleLayoutSubviewsMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP swizzleImp = (IMP)__UIViewLayoutSubviews;
        Method method = class_getInstanceMethod([UIView class],
                @selector(layoutSubviews));
        originalLayoutSubviewsImp = method_setImplementation(method, swizzleImp);
    });
}

@end
