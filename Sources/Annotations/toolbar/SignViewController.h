//
//  SignView.h
//  Reader
//
//  Created by Young Kim on 2017-08-18.
//
//

#import <UIKit/UIKit.h>

@protocol SignViewDelegate <NSObject>
@optional
- (void) closeSign;
- (void) saveSign:(UIImage *)imgSign;
@end

@interface SignViewController : UIViewController

@property (nonatomic, weak) id<SignViewDelegate> signDelegate;


@end
