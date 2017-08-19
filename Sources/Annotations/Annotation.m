//
//  Annotation.m
//	ThatPDF v0.3.1
//
//	Created by Brett van Zuiden.
//	Copyright © 2013 Ink. All rights reserved.
//

#import "Annotation.h"

@class Annotation;
@class CustomAnnotation;
@class TextAnnotation;
@class PathAnnotation;

@implementation Annotation

- (void) drawInContext:(CGContextRef) context {
    //Overridden
}

@end

@implementation CustomAnnotation
@synthesize block;
+ (id) customAnnotationWithBlock:(CustomAnnotationDrawingBlock)block {
    CustomAnnotation *ca = [[CustomAnnotation alloc] init];
    ca.block = block;
    return ca;
}

- (void) drawInContext:(CGContextRef)context {
    self.block(context);
}

@end;

@implementation TextAnnotation
@synthesize text;
@synthesize rect;
@synthesize font;

+ (id) textAnnotationWithText:(NSString *)text inRect:(CGRect)rect withFont:(UIFont*)font {
    TextAnnotation *ta = [[TextAnnotation alloc] init];
    ta.text = text;
    ta.rect = rect;
    ta.font = font;
    return ta;
}

- (void) drawInContext:(CGContextRef)context {
    
    UIGraphicsPushContext(context);

    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14]
                                                                forKey:NSFontAttributeName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.text attributes:attrsDictionary];
    [attrString drawAtPoint:CGPointMake(self.rect.origin.x, self.rect.origin.y)];
    UIGraphicsPopContext();
    //Otherwise we're upside-down
    /*
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
    
    CGContextSelectFont(context, "Arial", self.font.pointSize, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(context, self.rect.origin.x, self.rect.origin.y + self.font.pointSize,
                             [self.text cStringUsingEncoding:[NSString defaultCStringEncoding]],
                             [self.text length]);
    */
}

@end

@implementation PathAnnotation
+ (id) pathAnnotationWithPath:(CGPathRef)path color:(CGColorRef)color fill:(BOOL)fill{
    return [PathAnnotation pathAnnotationWithPath:path color:color lineWidth:3.0 fill:fill];
}

+ (id) pathAnnotationWithPath:(CGPathRef)path color:(CGColorRef)color lineWidth:(CGFloat)width fill:(BOOL)fill {
    PathAnnotation *pa = [[PathAnnotation alloc] init];
    pa.path = path;
    pa.color = color;
    pa.lineWidth = width;
    pa.fill = fill;
    return pa;
}

- (void) drawInContext:(CGContextRef)context {
    CGContextAddPath(context, self.path);
    CGContextSetLineWidth(context, self.lineWidth);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.color);
        CGContextFillPath(context);
    } else {
        CGContextSetStrokeColorWithColor(context, self.color);
        CGContextStrokePath(context);
    }
}
@end


@implementation ImageAnnotation
@synthesize image;
@synthesize rect;


+ (id) imageAnnotationWithImage:(UIImage *)image inRect:(CGRect)rect {
    ImageAnnotation *ia = [[ImageAnnotation alloc] init];
    ia.image = image;
    ia.rect = rect;
    return ia;
}

- (void) drawInContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    [image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    UIGraphicsPopContext();
}

@end
