//
//  NISignatureViewQuartzQuadratic.m
//  SignatureDemo
//
//  Created by Jason Harwig on 11/6/12.
//  Copyright (c) 2012 Near Infinity Corporation.

#import "NISignatureViewQuartzQuadratic.h"
#import <QuartzCore/QuartzCore.h>

static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface NISignatureViewQuartzQuadratic ()
{
    UIBezierPath *path;
    CGPoint previousPoint;
    NSMutableArray* points;
    UIColor* currentColor;
}

@end

@implementation NISignatureViewQuartzQuadratic

- (void)commonInit
{
    points = [NSMutableArray array];
    path = [self createBezierPath];
    
    // Capture touches
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self commonInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self commonInit];
    return self;
}

- (void)erase
{
    path = [self createBezierPath];
    [points removeAllObjects];
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

- (void)tap:(UITapGestureRecognizer*)tap
{
    CGPoint currentPoint = [tap locationInView:self];
    [points addObject:[NSValue valueWithCGPoint:currentPoint]];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(currentColor){
        [currentColor setStroke];
    }else{
        [[UIColor blackColor] setStroke];
    }
    [path stroke];
    
    for (NSValue* value in points) {
        CGPoint point = [value CGPointValue];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(context, CGRectMake(point.x, point.y, 10.0, 10.0));
        CGContextDrawPath(context, kCGPathFill);
        CGContextStrokePath(context);
    }
}

- (UIBezierPath*)createBezierPath
{
    UIBezierPath* newPath = [UIBezierPath bezierPath];
    newPath.lineWidth = 5.0;
    return newPath;
}

- (void)red
{
    currentColor = [UIColor redColor];
}

- (void)black
{
    currentColor = [UIColor blackColor];
}

- (void)blue
{
    currentColor = [UIColor blueColor];
}
@end
