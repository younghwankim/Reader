//
//  InputTextViewController.m
//  Reader
//
//  Created by Young Kim on 2017-08-18.
//
//

#import "InputTextViewController.h"

@interface InputTextViewController () {
    NSArray *fontArray;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;

@property (weak, nonatomic) IBOutlet UIButton *boldButton;
@property (weak, nonatomic) IBOutlet UIButton *italicButton;

@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    fontArray = @[@12,@13,@14,@15,@16,@17,@18,@20,@24,@30,@36,@48,@60,@72,@96];
    
    self.textView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.view.layer.cornerRadius = 10.0;
    
    if(self.fontColor == 1 || self.fontColor == 4) {
        self.textView.backgroundColor = [UIColor grayColor];
    } else {
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    if(self.fontSize < 12) {
        self.fontSize = 15;
    }
    [self updateStatusLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateStatusLabel {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *whiteImage = [UIImage imageNamed:@"wcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *blackImage = [UIImage imageNamed:@"bcheckmark" inBundle:bundle compatibleWithTraitCollection:nil];
    
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%d", self.fontSize];
    NSString *strFontName;

    if(self.isBold){
        if(self.isItalic){
            strFontName = @"HelveticaNeue-BoldItalic";
        }else{
            strFontName = @"HelveticaNeue-Bold";
        }
    }else{
        if(self.isItalic){
            strFontName = @"HelveticaNeue-Italic";
        }else{
            strFontName = @"HelveticaNeue";
        }
    }
    self.currentFont =  [UIFont fontWithName:strFontName size:self.fontSize];
    
    if(self.fontColor == 0){
        self.currentColor = [UIColor blackColor];
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:whiteImage forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
    }else if(self.fontColor == 1){
        self.currentColor = [UIColor whiteColor];
        [self.whiteButton setImage:blackImage forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
    }else if(self.fontColor == 2){
        self.currentColor = [UIColor blueColor];
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:whiteImage forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
    }else if(self.fontColor == 3){
        self.currentColor = [UIColor greenColor];
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:whiteImage forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
    }else if(self.fontColor == 4){
        self.currentColor = [UIColor yellowColor];
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:blackImage forState:UIControlStateNormal];
        [self.redButton setImage:nil forState:UIControlStateNormal];
    }else if(self.fontColor == 5){
        self.currentColor = [UIColor redColor];
        [self.whiteButton setImage:nil forState:UIControlStateNormal];
        [self.blackButton setImage:nil forState:UIControlStateNormal];
        [self.blueButton setImage:nil forState:UIControlStateNormal];
        [self.greenButton setImage:nil forState:UIControlStateNormal];
        [self.yellowButton setImage:nil forState:UIControlStateNormal];
        [self.redButton setImage:whiteImage forState:UIControlStateNormal];
    }
    if(self.fontColor == 1 || self.fontColor == 4) {
        self.textView.backgroundColor = [UIColor grayColor];
    } else {
        self.textView.backgroundColor = [UIColor whiteColor];
    }

    self.textView.textColor = self.currentColor;
    self.textView.font = self.currentFont;
}

- (IBAction)saveClicked:(UIButton *)sender {
    [self.textView resignFirstResponder];
    if(self.textView.text == nil || [self.textView.text length]==0){
        if(self.inputTextDelegate)
            [self.inputTextDelegate closeInputText];
    }else{
        if(self.inputTextDelegate)
            [self.inputTextDelegate saveInputText:self.textView.text font:self.currentFont color:self.currentColor];
    }
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if(self.inputTextDelegate)
        [self.inputTextDelegate closeInputText];
}

-(int) currentFontIndex {
    int i = 0;
    for( NSNumber *number in fontArray){
        
        if([number intValue] == self.fontSize){
            return i;
        }
        i++;
    }
    return 0;
}


- (IBAction)upClicked:(UIButton *)sender {
    int index = [self currentFontIndex];
    
    if(index== ([fontArray count]-1)){
        self.fontSize = [fontArray[index] intValue];
    } else{
        self.fontSize = [fontArray[index+1] intValue];
    }
    [self updateStatusLabel];
}

- (IBAction)downClicked:(UIButton *)sender {
    int index = [self currentFontIndex];
    
    if(index== 0){
        self.fontSize = [fontArray[0] intValue];
    } else{
        self.fontSize = [fontArray[index-1] intValue];
    }
    [self updateStatusLabel];
}

- (IBAction)boldClicked:(UIButton *)sender {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *boldOffImage = [UIImage imageNamed:@"bold_off" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *boldOnImage = [UIImage imageNamed:@"bold_on" inBundle:bundle compatibleWithTraitCollection:nil];
    self.isBold = !self.isBold;
    
    if(self.isBold)
        [self.boldButton setImage:boldOnImage forState:UIControlStateNormal];
    else
        [self.boldButton setImage:boldOffImage forState:UIControlStateNormal];
    
    [self updateStatusLabel];
}

- (IBAction)italicClicked:(UIButton *)sender {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *italicOffImage = [UIImage imageNamed:@"italic_off" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *italicOnImage = [UIImage imageNamed:@"italic_on" inBundle:bundle compatibleWithTraitCollection:nil];
    self.isItalic = !self.isItalic;
    
    if(self.isItalic)
        [self.italicButton setImage:italicOnImage forState:UIControlStateNormal];
    else
        [self.italicButton setImage:italicOffImage forState:UIControlStateNormal];
    [self updateStatusLabel];
}

- (IBAction)colorClicked:(UIButton *)sender {
    self.fontColor = (int)sender.tag;
    [self updateStatusLabel];
}

@end
