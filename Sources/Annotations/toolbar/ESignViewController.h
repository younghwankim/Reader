//
//  ESignViewController.h
//  Reader
//
//  Created by Young Kim on 2017-08-19.
//
//

#import <UIKit/UIKit.h>

@protocol ESignViewDelegate <NSObject>
@optional
- (void) closeESign;
- (void) saveESign:(UIImage *)imgSign;
@end


@interface ESignViewController : UIViewController
@property (nonatomic, weak) id<ESignViewDelegate> esignDelegate;
@end
