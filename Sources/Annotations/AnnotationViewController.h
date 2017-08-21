//
//  AnnotationViewController.h
//	ThatPDF v0.3.1
//
//	Created by Brett van Zuiden.
//	Copyright © 2013 Ink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReaderDocument.h"
#import "Annotation.h"
#import "AnnotationStore.h"
#import "ReaderContentView.h"

extern NSString *const AnnotationViewControllerType_None;
extern NSString *const AnnotationViewControllerType_Sign;
extern NSString *const AnnotationViewControllerType_RedPen;
extern NSString *const AnnotationViewControllerType_Text;

@interface AnnotationViewController : UIViewController
@property NSString *annotationType;
@property ReaderDocument *document;
@property NSInteger currentPage;

@property NSString *fontName;
@property UIColor *fontColor;
@property int fontSize;

@property CGColorRef pathColor;
@property int lineWidth;

- (id)initWithDocument:(ReaderDocument *)document;
- (void)moveToPage:(int)page contentView:(ReaderContentView*) view;
- (void) hide;
- (void) clear;
- (void) undo;

- (void) showInputTextView;
- (void) closeInputTextView;


- (AnnotationStore*) annotations;
- (void) setCurrentPenColor:(UIColor *)penColor;

- (void) showSignView;
- (void) saveESign:(UIImage *)imgSign;
- (void) closeESign;
@end
