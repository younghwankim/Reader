//
//  InputTextViewController.m
//  Reader
//
//  Created by Young Kim on 2017-08-18.
//
//

#import "InputTextViewController.h"

@interface InputTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.view.layer.cornerRadius = 10.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveClicked:(UIButton *)sender {
    [self.textView resignFirstResponder];
    if(self.textView.text == nil || [self.textView.text length]==0){
        if(self.inputTextDelegate)
            [self.inputTextDelegate closeInputText];
    }else{
        if(self.inputTextDelegate)
            [self.inputTextDelegate saveInputText:self.textView.text];
    }
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if(self.inputTextDelegate)
        [self.inputTextDelegate closeInputText];
}

@end
