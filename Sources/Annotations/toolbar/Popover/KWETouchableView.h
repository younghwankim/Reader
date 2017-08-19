//
//  KWETouchableView.h
//  KWEPopover
//
//  Created by KWErner Altewischer on 12/21/10.
//  Copyright 2010 KWErner IT Consultancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KWETouchableView;

/**
  * delegate to receive touch events
  */
@protocol KWETouchableViewDelegate<NSObject>

@optional
- (void)viewWasTouched:(KWETouchableView *)view;
- (CGRect)fillRectForView:(KWETouchableView *)view;

@end

/**
 * View that can handle touch events and/or disable touch forwording to child views
 */
@interface KWETouchableView : UIView

@property (nonatomic, assign) BOOL touchForwardingDisabled;
@property (nonatomic, weak) id <KWETouchableViewDelegate> delegate;
@property (nonatomic, copy) NSArray *passthroughViews;
@property (nonatomic, strong) UIView *fillView;
@property (nonatomic, assign) BOOL gestureBlockingEnabled;

- (void)setFillColor:(UIColor *)fillColor;

@end
