//
//  SignView.m
//  Reader
//
//  Created by Young Kim on 2017-08-18.
//
//

#import "SignViewController.h"
#import "NISignatureViewQuartzQuadratic.h"
#import "UIView-JTViewToImage.h"
#import "UIImage+Trim.h"

@interface SignViewController ()
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignPad;
@property (weak, nonatomic) IBOutlet NISignatureViewQuartzQuadratic *signatureView;

@end

@implementation SignViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.selectView.backgroundColor = [UIColor blackColor];
    self.selectView.frame = CGRectMake(38,182,18,5);
    
    self.imgSignPad.layer.cornerRadius = 10.0;
    self.view.layer.cornerRadius = 10.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if(self.signDelegate)
        [self.signDelegate closeSign];
}

- (IBAction)saveClicked:(UIButton *)sender {
    UIImage *imgSign = [self.signatureView toImage];
    
    imgSign = [imgSign imageByTrimmingTransparentPixels];
    
    if(imgSign.size.width > 48.0f && imgSign.size.height > 48.0f){
        [self.signDelegate saveSign:imgSign];
    }else{
        CGRect rcFrame = CGRectMake(0,0,imgSign.size.width<48.0f ? 48.0f:imgSign.size.width ,
                                    imgSign.size.height<48.0f ? 48.0f:imgSign.size.height);
        UIImageView *view = [[UIImageView alloc] initWithFrame:rcFrame];
        view.contentMode = UIViewContentModeTopLeft;
        view.image = imgSign;
        view.backgroundColor = [UIColor clearColor];
        
        imgSign = [view toImage];
        if(self.signDelegate)
            [self.signDelegate saveSign:imgSign];
    }
}

- (IBAction)black:(UIButton *)sender {
    self.selectView.backgroundColor = [UIColor blackColor];
    self.selectView.frame = CGRectMake(38,182,18,5);
    [self.signatureView black];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)blue:(UIButton *)sender {
    self.selectView.backgroundColor = [UIColor blueColor];
    self.selectView.frame = CGRectMake(64,182,18,5);
    
    [self.signatureView blue];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)red:(UIButton *)sender {
    self.selectView.backgroundColor = [UIColor redColor];
    self.selectView.frame = CGRectMake(90,182,18,5);
    [self.signatureView red];
    [self.signatureView setNeedsDisplay];
}

- (IBAction)clear:(UIButton *)sender {
    [self.signatureView erase];
}

@end
