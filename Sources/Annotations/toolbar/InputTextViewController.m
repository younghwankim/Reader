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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *colorStatus;

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    fontArray = @[@12,@13,@14,@15,@16,@17,@18,@20,@24,@36,@48,@72];
    
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
    self.fontSizeLabel.text = [NSString stringWithFormat:@"%d", self.fontSize];
    NSString *strFont;
    NSString *strFontName;

    if(self.isBold){
        if(self.isItalic){
            strFont = @"Italic Bold";
            strFontName = @"HelveticaNeue-BoldItalic";
        }else{
            strFont = @"Bold";
            strFontName = @"HelveticaNeue-Bold";
        }
    }else{
        if(self.isItalic){
            strFont = @"Italic";
            strFontName = @"HelveticaNeue-Italic";
        }else{
            strFont = @"Regular";
            strFontName = @"HelveticaNeue";
        }
    }
    self.currentFont =  [UIFont fontWithName:strFontName size:self.fontSize];
    
    if(self.fontColor == 0){
        self.currentColor = [UIColor blackColor];
    }else if(self.fontColor == 1){
        self.currentColor = [UIColor whiteColor];
    }else if(self.fontColor == 2){
        self.currentColor = [UIColor blueColor];
    }else if(self.fontColor == 3){
        self.currentColor = [UIColor greenColor];
    }else if(self.fontColor == 4){
        self.currentColor = [UIColor yellowColor];
    }else if(self.fontColor == 5){
        self.currentColor = [UIColor redColor];
    }
    if(self.fontColor == 1 || self.fontColor == 4) {
        self.textView.backgroundColor = [UIColor grayColor];
    } else {
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    self.colorStatus.backgroundColor = self.currentColor;
    self.statusLabel.text = [NSString stringWithFormat:@"%@ - %d",strFont,self.fontSize];
    

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
    self.isBold = !self.isBold;
    [self updateStatusLabel];
}

- (IBAction)italicClicked:(UIButton *)sender {
    self.isItalic = !self.isItalic;
    [self updateStatusLabel];
}

- (IBAction)colorClicked:(UIButton *)sender {
    self.fontColor = sender.tag;
    [self updateStatusLabel];
}

@end
