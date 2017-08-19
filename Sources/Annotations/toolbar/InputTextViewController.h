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
@end
@interface InputTextViewController : UIViewController

@property (nonatomic, weak) id<InputTextVCDelegate> inputTextDelegate;

@end
