//
//  InputTextViewController.h
//  Reader
//
//  Created by Young Kim on 2017-08-18.
//
//

#import <UIKit/UIKit.h>
@protocol InputTextVCDelegate <NSObject>
@optional
- (void) closeInputText;
- (void) saveInputText:(NSString *)textString;
- (void) saveInputText:(NSString *)textString font:(UIFont*)currentFont color:(UIColor*)currentColor;
@end
@interface InputTextViewController : UIViewController

@property (nonatomic, weak) id<InputTextVCDelegate> inputTextDelegate;
@property (nonatomic) int fontSize;
@property (nonatomic) BOOL isBold;
@property (nonatomic) BOOL isItalic;
@property (nonatomic) int fontColor; //1= white, 0=black,2=blue, 3= green,4=yellow,5=red

@property (nonatomic,strong) UIFont *currentFont;
@property (nonatomic,strong) UIColor *currentColor;
@property (nonatomic) BOOL isLargeMode;
@end
