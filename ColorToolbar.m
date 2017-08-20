//
//  ColorToolbar.m
//  Reader
//
//  Created by Young Kim on 2017-08-20.
//
//

#import "ColorToolbar.h"
@interface ColorToolbar  ()
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@end
@implementation ColorToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//[undoButton setImage:[UIImage imageNamed:@"undo" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];

- (IBAction)colorClicked:(UIButton *)sender {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *blackImage = [UIImage imageNamed:@"bcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    
    if(sender.tag == 0){//black
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:whiteImage forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor blackColor]];
        }
    }else if(sender.tag == 1){//white
        [self.whiteButton setImage:blackImage forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor whiteColor]];
        }
    }else if(sender.tag == 2){//blue
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:whiteImage forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor blueColor]];
        }
    }else if(sender.tag == 3){//green
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:whiteImage forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor greenColor]];
        }
    }else if(sender.tag == 4){//yellow
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:blackImage forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor yellowColor]];
        }
    }else if(sender.tag == 5){//red
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:whiteImage forState:UIControlStateNormal];
        if(self.colorDelegate){
            [self.colorDelegate checkedColor:[UIColor redColor]];
        }
    }
}

@end
