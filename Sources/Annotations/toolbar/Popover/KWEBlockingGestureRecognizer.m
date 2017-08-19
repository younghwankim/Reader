//
//  KWETouchDownGestureRecognizer.m
//  KWEPopover
//
//  Created by KWErner Altewischer on 18/09/14.
//  Copyright (c) 2014 KWErner IT Consultancy. All rights reserved.
//

#import "KWEBlockingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation KWEBlockingGestureRecognizer {
    NSMutableArray *_disabledGestureRecognizers;
}

- (id)init {
    return [self initWithTarget:self action:@selector(__dummyAction)];
}

- (void)dealloc {
    [self restoreDisabledGestureRecognizers];
}

- (id)initWithTarget:(id)target action:(SEL)action {
    if ((self = [super initWithTarget:target action:action])) {
        self.cancelsTouchesInView = NO;
        _disabledGestureRecognizers = [NSMutableArray new];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateRecognized;
    [self restoreDisabledGestureRecognizers];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
    [self restoreDisabledGestureRecognizers];
}

- (void)restoreDisabledGestureRecognizers {
    for (UIGestureRecognizer *gr in _disabledGestureRecognizers) {
        gr.enabled = YES;
    }
    [_disabledGestureRecognizers removeAllObjects];
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return [self shouldBeRequiredToFailByGestureRecognizer:preventedGestureRecognizer];
}

- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL alloKWEd = [self isGestureRecognizerAlloKWEd:otherGestureRecognizer];
    if (!alloKWEd) {
        if (otherGestureRecognizer.isEnabled) {
            otherGestureRecognizer.enabled = NO;
            [_disabledGestureRecognizers addObject:otherGestureRecognizer];
        }
    }
    return !alloKWEd;
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)isGestureRecognizerAlloKWEd:(UIGestureRecognizer *)gr {
    return [gr.view isDescendantOfView:self.view];
}

- (void)__dummyAction {
    
}

@end
