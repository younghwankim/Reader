//
//  KWEPopoverContainerViewProperties.m
//  KWEPopover
//
//  Created by KWErner Altewischer on 19/11/15.
//  Copyright © 2015 KWErner IT Consultancy. All rights reserved.
//

#import "KWEPopoverContainerViewProperties.h"

@implementation KWEPopoverContainerViewProperties {
    
}

#define IMAGE_FOR_NAME(arrowImage, arrowImageName)	((arrowImage != nil) ? (arrowImage) : (arrowImageName == nil ? nil : [UIImage imageNamed:arrowImageName]))

- (id)init {
    if ((self = [super init])) {
        self.shadowOffset = CGSizeZero;
        self.shadowOpacity = 0.5;
        self.shadowRadius = 3.0;
    }
    return self;
}

- (UIImage *)upArrowImage {
    UIImage *image = [UIImage new];
    return image;
    //return IMAGE_FOR_NAME(_upArrowImage, _upArrowImageName);
}

- (UIImage *)downArrowImage {
    UIImage *image = [UIImage new];
    return image;
    //return IMAGE_FOR_NAME(_downArrowImage, _downArrowImageName);
}

- (UIImage *)leftArrowImage {
    UIImage *image = [UIImage new];
    return image;
    //return IMAGE_FOR_NAME(_leftArrowImage, _leftArrowImageName);
}

- (UIImage *)rightArrowImage {
    UIImage *image = [UIImage new];
    return image;
    //return IMAGE_FOR_NAME(_rightArrowImage, _rightArrowImageName);
}

- (UIImage *)bgImage {
    UIImage *image = [UIImage new];
    return image;//IMAGE_FOR_NAME(_bgImage, _bgImageName);
}


@end
