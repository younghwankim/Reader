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

@property (weak, nonatomic) IBOutlet NISignatureViewQuartzQuadratic *signatureView;
@end

@implementation ESignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self enableLandscapeRotation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enableLandscapeRotation: (BOOL)enable {
    
    if (!enable && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationLandscapeRight;
    }else{
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self enableLandscapeRotation:NO];
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}


- (IBAction)blackClicked:(UIButton *)sender {
    [self.signatureView black];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)redClicked:(UIButton *)sender {
    [self.signatureView red];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)blueClicked:(UIButton *)sender {
    [self.signatureView blue];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if(self.esignDelegate)
        [self.esignDelegate closeESign];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
