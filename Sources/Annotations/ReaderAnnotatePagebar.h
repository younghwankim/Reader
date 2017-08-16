//
//	ReaderAnnotatePagebar.h
//	ThatPDF v0.3.1
//
//	Created by Brett van Zuiden.
//	Copyright © 2013 Ink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIXToolbarView.h"


@class ReaderAnnotatePagebar;
@class ReaderDocument;

@protocol ReaderAnnotatePagebarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar doneButton:(UIButton *)button;
- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar cancelButton:(UIButton *)button;
- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar signButton:(UIButton *)button;
- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar redPenButton:(UIButton *)button;
- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar textButton:(UIButton *)button;
- (void)tappedInAnnotatePagebar:(ReaderAnnotatePagebar *)Pagebar undoButton:(UIButton *)button;

@end

@interface ReaderAnnotatePagebar : UIXToolbarView

@property (nonatomic, unsafe_unretained, readwrite) id <ReaderAnnotatePagebarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)hidePagebar;
- (void)showPagebar;

- (void)setUndoButtonState:(BOOL)state;
- (void)setSignButtonState:(BOOL)state;
- (void)setRedPenButtonState:(BOOL)state;
- (void)setTextButtonState:(BOOL)state;

@end
