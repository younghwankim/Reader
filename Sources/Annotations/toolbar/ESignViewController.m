//
//  ESignViewController.m
//  Reader
//
//  Created by Young Kim on 2017-08-19.
//
//

#import "ESignViewController.h"
#import "NISignatureViewQuartzQuadratic.h"
#import "UIView-JTViewToImage.h"
#import "UIImage+Trim.h"

@interface ESignViewController ()
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@property (weak, nonatomic) IBOutlet NISignatureViewQuartzQuadratic *signatureView;
@end

@implementation ESignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.blackButton setImage:whiteImage forState:UIControlStateNormal];
    [self.blueButton setImage:nil forState:UIControlStateNormal];
    [self.redButton setImage:nil forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.superview.bounds = CGRectMake(0, 0, 736, 414);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)blackClicked:(UIButton *)sender {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.blackButton setImage:whiteImage forState:UIControlStateNormal];
    [self.blueButton setImage:nil forState:UIControlStateNormal];
    [self.redButton setImage:nil forState:UIControlStateNormal];
    
    
    [self.signatureView black];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)redClicked:(UIButton *)sender {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.redButton setImage:whiteImage forState:UIControlStateNormal];
    [self.blackButton setImage:nil forState:UIControlStateNormal];
    [self.blueButton setImage:nil forState:UIControlStateNormal];
    
    [self.signatureView red];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)blueClicked:(UIButton *)sender {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.blueButton setImage:whiteImage forState:UIControlStateNormal];
    [self.redButton setImage:nil forState:UIControlStateNormal];
    [self.blackButton setImage:nil forState:UIControlStateNormal];
    
    [self.signatureView blue];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if(self.esignDelegate)
        [self.esignDelegate closeESign];
}

- (IBAction)clearClicked:(UIButton *)sender {
    [self.signatureView erase];
}

- (IBAction)saveClicked:(UIButton *)sender {
    UIImage *imgSign = [self.signatureView toImage];
    
    imgSign = [imgSign imageByTrimmingTransparentPixels];
    
    if(imgSign.size.width > 48.0f && imgSign.size.height > 48.0f){
        if(self.esignDelegate)
            [self.esignDelegate saveESign:imgSign];
    }else{
        CGRect rcFrame = CGRectMake(0,0,imgSign.size.width<48.0f ? 48.0f:imgSign.size.width ,
                                    imgSign.size.height<48.0f ? 48.0f:imgSign.size.height);
        UIImageView *view = [[UIImageView alloc] initWithFrame:rcFrame];
        view.contentMode = UIViewContentModeTopLeft;
        view.image = imgSign;
        view.backgroundColor = [UIColor clearColor];
        
        imgSign = [view toImage];
        if(self.esignDelegate)
            [self.esignDelegate saveESign:imgSign];
    }
}

@end
