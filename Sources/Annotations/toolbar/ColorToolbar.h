//
//  ColorToolbar.h
//  Reader
//
//  Created by Young Kim on 2017-08-20.
//
//

#import "UIXToolbarView.h"

@protocol ColorToolbarDelegate <NSObject>
@optional

- (void) checkedColor:(UIColor *)color;

@end

@interface ColorToolbar : UIXToolbarView
@property (nonatomic, weak) id<ColorToolbarDelegate> colorDelegate;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@end
