//
//  AnnotationViewController.m
//	ThatPDF v0.3.1
//
//	Created by Brett van Zuiden.
//	Copyright © 2013 Ink. All rights reserved.
//

#import "AnnotationViewController.h"
#import "KWEPopoverController.h"
#import "SignViewController.h"
#import "UIImage+Trim.h"
#import "SPUserResizableView.h"
#import "UIView-JTViewToImage.h"
#import "InputTextViewController.h"
#import "InputTextViewController.h"
#import "ESignViewController.h"

NSString *const AnnotationViewControllerType_None = @"None";
NSString *const AnnotationViewControllerType_Sign = @"Sign";
NSString *const AnnotationViewControllerType_RedPen = @"RedPen";
NSString *const AnnotationViewControllerType_Text = @"Text";

int const ANNOTATION_IMAGE_TAG = 431;
CGFloat const TEXT_FIELD_WIDTH = 300;
CGFloat const TEXT_FIELD_HEIGHT = 32;

@interface AnnotationViewController () <SignViewDelegate, SPUserResizableViewDelegate, InputTextVCDelegate, ESignViewDelegate>
@property (nonatomic, retain) KWEPopoverController *wePopoverController;
@end

@implementation AnnotationViewController {
    CGPoint lastPoint;
    UIImageView *image;
    UIView *pageView;
    CGColorRef annotationColor;
    CGColorRef signColor;
    NSString *_annotationType;
    AnnotationStore *annotationStore;
    //We need both because of the UIBezierPath nonsense
    NSMutableArray *currentPaths;
    CGMutablePathRef currPath;
    
    BOOL didMove;
    
    UILabel *textField;
    
    SPUserResizableView *imageResizableView;
    BOOL isPopUpMode;
}

@dynamic annotationType;

- (id) initWithDocument:(ReaderDocument *)readerDocument
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.annotationType = AnnotationViewControllerType_None;
        self.document = readerDocument;
        
        annotationColor = [UIColor redColor].CGColor;
        signColor = [UIColor blackColor].CGColor;
        self.currentPage = 0;
        image = [[UIImageView alloc] initWithImage:nil];
        image.frame = CGRectMake(0,0,100,100); //so we don't error out
        currentPaths = [NSMutableArray array];
        
        annotationStore = [[AnnotationStore alloc] initWithPageCount:[readerDocument.pageCount intValue]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.userInteractionEnabled = ![self.annotationType isEqualToString:AnnotationViewControllerType_None];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
  
    image = [self createImageView];
    [pageView addSubview:image];

    textField = [self createTextField];
    [pageView addSubview:textField];
    isPopUpMode = NO;
}


- (UIImageView*) createImageView {
    UIImageView *temp = [[UIImageView alloc] initWithImage:nil];
    temp.frame = pageView.frame;
    temp.tag = ANNOTATION_IMAGE_TAG;
    return temp;
}

- (UILabel*) createTextField {
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(400, 400, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    temp.hidden = YES;
    temp.font = [UIFont systemFontOfSize:14];
//    temp.borderStyle = UITextBorderStyleLine;
//    temp.font = [UIFont systemFontOfSize:14];
    return temp;
}

- (NSString*) annotationType {
    return _annotationType;
}

- (void) setAnnotationType:(NSString *)annotationType {
    //Close current annotation
    [self finishCurrentAnnotation];
    textField.text = @"";
    _annotationType = annotationType;
    self.view.userInteractionEnabled = ![self.annotationType isEqualToString:AnnotationViewControllerType_None];
}

- (void) finishCurrentAnnotation {
    Annotation* annotation = [self getCurrentAnnotation];
    
    if (annotation) {
        if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text]) {
            if(textField.text.length > 0){
                [annotationStore addAnnotation:annotation toPage:(int)self.currentPage];
            }
        } else {
            [annotationStore addAnnotation:annotation toPage:(int)self.currentPage];
        }
    }
    if(imageResizableView){
        [imageResizableView hideEditingHandles];
    }
    
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text]) {
        [self refreshDrawing];
    }

    
    textField.hidden = YES;
    [currentPaths removeAllObjects];
    currPath = nil;
}

- (AnnotationStore*) annotations {
    [self finishCurrentAnnotation];
    return annotationStore;
}

- (Annotation*) getCurrentAnnotation {
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text]) {
        if (!textField.hidden) {
            [textField resignFirstResponder];
            return [TextAnnotation textAnnotationWithText:textField.text inRect:textField.frame withFont:textField.font];
        }
        return nil;
    }
    
    if (!currPath && ([currentPaths count] == 0) && imageResizableView==nil) {
        return nil;
    }
    
    CGMutablePathRef basePath = CGPathCreateMutable();
    for (UIBezierPath *bpath in currentPaths) {
        CGPathAddPath(basePath, NULL, bpath.CGPath);
    }
    CGPathAddPath(basePath, NULL, currPath);
    
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_RedPen]) {
        return [PathAnnotation pathAnnotationWithPath:basePath color:annotationColor lineWidth:5.0 fill:NO];
    }
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Sign]) {
        if(imageResizableView){
            [imageResizableView hideEditingHandles];
            return [ImageAnnotation imageAnnotationWithImage:[imageResizableView toImage] inRect:imageResizableView.frame];
        }
    }
    return nil;
}

- (void) moveToPage:(int)page contentView:(ReaderContentView*) view {
    if (page != self.currentPage || !pageView) {
        [self finishCurrentAnnotation];
        
        self.currentPage = page;
        
        pageView = [view pageView];
        //Create a new one because the old one may be deallocated or have a deallocated parent
        //First, erase any contents though
        if (image.superview != nil) {
            image.image = nil;
        }
        if (textField.superview != nil) {
            textField.hidden = YES;
        }
        
        image = [self createImageView];
        [pageView addSubview:image];
        textField = [self createTextField];
        [pageView addSubview:textField];
        
        [self refreshDrawing];
    }
}

- (void) clear{
    //Setting up a blank image to start from. This displays the current drawing
    textField.text = @"";
    image.image = nil;
    currPath = nil;
    [currentPaths removeAllObjects];
    [annotationStore empty];
    if(imageResizableView && imageResizableView.superview )
        [imageResizableView removeFromSuperview];
    imageResizableView = nil;
}

- (void) hide {
    textField.hidden = YES;
    [self.view removeFromSuperview];
}

- (void) undo {
    //Immediate path
    if (currPath != nil) {
        currPath = nil;
    } else if ([currentPaths count] > 0) {
        //if we have a current path, undo it
        [currentPaths removeLastObject];
    } else if (imageResizableView) {
        [imageResizableView removeFromSuperview];
        imageResizableView = nil;
    } else if ([textField.text length] > 0) {
        textField.text = @"";
        textField.hidden = YES;
    }else {
        //pop from store
        [annotationStore undoAnnotationOnPage:(int)self.currentPage];
    }
    
    [self refreshDrawing];
}

- (void) refreshDrawing {
    UIGraphicsBeginImageContextWithOptions(pageView.frame.size, NO, 1.5f);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Draw previous paths
    [annotationStore drawAnnotationsForPage:(int)self.currentPage inContext:currentContext];
    
    CGContextSetShouldAntialias(currentContext, YES);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_RedPen]) {
        //Setup style
        CGContextSetLineCap(currentContext, kCGLineCapRound);
        CGContextSetLineWidth(currentContext, 5.0);
        CGContextSetStrokeColorWithColor(currentContext, annotationColor);
    }
//    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Sign]) {
//        //Setup style
//        CGContextSetLineCap(currentContext, kCGLineCapRound);
//        CGContextSetLineWidth(currentContext, 3.0);
//        CGContextSetStrokeColorWithColor(currentContext, signColor);
//    }
    
    //Draw Paths
    for (UIBezierPath *path in currentPaths) {
        CGContextAddPath(currentContext, path.CGPath);
    }
    
    CGContextAddPath(currentContext, currPath);
    CGContextStrokePath(currentContext);
    
    //Saving
    image.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(isPopUpMode)
        return;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:pageView];
    
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text]) {
        
        textField.frame = CGRectMake(lastPoint.x, lastPoint.y, textField.frame.size.width, textField.frame.size.height);

        textField.hidden = NO;
    } else if ([self.annotationType isEqualToString:AnnotationViewControllerType_Sign]){
        [imageResizableView touchesBegan:touches withEvent:event];
        
    } else {
        if (currPath) {
            [currentPaths addObject:[UIBezierPath bezierPathWithCGPath:currPath]];
        }
        currPath = CGPathCreateMutable();
        
        CGPathMoveToPoint(currPath, NULL, lastPoint.x, lastPoint.y);
        
    }
    didMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(isPopUpMode)
        return;
    
    didMove = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:pageView];
    
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text] && self.wePopoverController==nil) {
        textField.frame = CGRectMake(lastPoint.x, lastPoint.y, textField.frame.size.width, textField.frame.size.height);
    } else if ([self.annotationType isEqualToString:AnnotationViewControllerType_RedPen]){
        //Update path
        CGPathAddLineToPoint(currPath, NULL, currentPoint.x, currentPoint.y);
        [self refreshDrawing];
    } else if ([self.annotationType isEqualToString:AnnotationViewControllerType_Sign]){
        [imageResizableView touchesMoved:touches withEvent:event];
        
    }
    lastPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(isPopUpMode)
        return;
    
    if ([self.annotationType isEqualToString:AnnotationViewControllerType_Text]) {
        return;
    } else if ([self.annotationType isEqualToString:AnnotationViewControllerType_Sign]) {
        [imageResizableView touchesEnded:touches withEvent:event];
        return;
    }

    if (!didMove) {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:pageView];
        CGPathAddEllipseInRect(currPath, NULL, CGRectMake(currentPoint.x - 2.f, currentPoint.y - 2.f, 4.f, 4.f));
        [self refreshDrawing];
    }
    didMove = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark InputTextView

- (void) showInputTextView {
    [self closeInputTextView];
    
    UIWindow *keyboardWindow = [UIApplication sharedApplication].keyWindow;//[UIApplication sharedApplication].windows.lastObject;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    InputTextViewController *contentViewController = [[InputTextViewController alloc]initWithNibName:@"InputTextViewController" bundle:bundle];
    contentViewController.inputTextDelegate = self;
    
    contentViewController.preferredContentSize = CGSizeMake(429,251);
    
    CGFloat myScale = [self calculateScale];
    
    self.wePopoverController = [[KWEPopoverController alloc] initWithContentViewController:contentViewController] ;
    self.wePopoverController.popoverContentSize = CGSizeMake(contentViewController.view.frame.size.width*myScale, contentViewController.view.frame.size.height*myScale);
    
    if(myScale < 1.0) {
        CGAffineTransform transform = contentViewController.view.transform;
        transform = CGAffineTransformScale(transform,  myScale,myScale);
        contentViewController.view.transform = transform;
    }
    
    CGRect rcFrame;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rcFrame = CGRectMake(-20,100,0,30);
    }else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if(screenRect.size.width > screenRect.size.height){
            rcFrame = CGRectMake(screenRect.size.width/2,50,20,30);
        }else{
            rcFrame = CGRectMake(screenRect.size.width/2,200,20,30);
        }
    }
    
    [self.wePopoverController presentPopoverFromRect:rcFrame
                                              inView:keyboardWindow
                            permittedArrowDirections:UIPopoverArrowDirectionUp
                                            animated:YES];
}

- (void) closeInputTextView {
    if (self.wePopoverController != nil && self.wePopoverController.popoverVisible) {
        [self.wePopoverController dismissPopoverAnimated:YES];
        self.wePopoverController = nil;
    }
}

#pragma mark InputTextVCDelegate
- (void) closeInputText {
    [self closeInputTextView];
}

- (void) saveInputText:(NSString *)textString {
    [self closeInputTextView];
    
    CGRect visibleRect = [self.view convertRect:pageView.bounds toView:pageView];
    
    textField.text = textString;
    
    CGSize size = [textField sizeThatFits:CGSizeMake(250, CGFLOAT_MAX)];
    
    CGRect labelFrame = CGRectMake((visibleRect.origin.x < 0 ? 20 : visibleRect.origin.x + 20), (visibleRect.origin.y < 0 ? 100 : visibleRect.origin.y + 100), size.width, size.height);
    textField.frame = labelFrame;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.hidden = NO;
}

#pragma mark SignView
- (void) showSignView {

    isPopUpMode = YES;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    ESignViewController *eSignVC = [[ESignViewController alloc]initWithNibName:@"ESignViewController" bundle:bundle];
    eSignVC.esignDelegate = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        eSignVC.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:eSignVC animated:YES completion:nil];
}

- (void) closeESign {
    isPopUpMode = NO;
}

- (void) saveESign:(UIImage *)imgSign {
    isPopUpMode = NO;
    CGRect visibleRect = [self.view convertRect:pageView.bounds toView:pageView];
    
    if(imgSign.size.width >300 || imgSign.size.height >300){
        if(imgSign.size.width > imgSign.size.height) {
            imgSign =[imgSign scaleImageToSize:CGSizeMake(300,(300 * imgSign.size.height / imgSign.size.width))];
        } else {
            imgSign =[imgSign scaleImageToSize:CGSizeMake((300 * imgSign.size.width/imgSign.size.height) ,300)];
        }
    }
    
    CGRect imageFrame = CGRectMake((visibleRect.origin.x < 0 ? 20 : visibleRect.origin.x + 20), (visibleRect.origin.y < 0 ? 100 : visibleRect.origin.y + 100), imgSign.size.width, imgSign.size.height);
    
    imageResizableView = [[SPUserResizableView alloc] initWithFrame:imageFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imgSign];
    imageResizableView.contentView = imageView;
    imageResizableView.delegate = self;
    [imageResizableView removeFromSuperview];
    [pageView addSubview:imageResizableView];
}


- (void) showOldSignView {
    
    [self closeSignView];
    
    UIWindow *keyboardWindow = [UIApplication sharedApplication].keyWindow;//[UIApplication sharedApplication].windows.lastObject;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    SignViewController *contentViewController = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:bundle];
    contentViewController.signDelegate = self;
    
    contentViewController.preferredContentSize = CGSizeMake(432,250);
    
    CGFloat myScale = [self calculateScale];
    
    self.wePopoverController = [[KWEPopoverController alloc] initWithContentViewController:contentViewController] ;
    self.wePopoverController.popoverContentSize = CGSizeMake(contentViewController.view.frame.size.width*myScale, contentViewController.view.frame.size.height*myScale);
    
    if(myScale < 1.0) {
        CGAffineTransform transform = contentViewController.view.transform;
        transform = CGAffineTransformScale(transform,  myScale,myScale);
        contentViewController.view.transform = transform;
    }
    
    CGRect rcFrame;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rcFrame = CGRectMake(-20,100,0,30);
    }else{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        rcFrame = CGRectMake(screenRect.size.width/2,200,20,30);
    }
    
    [self.wePopoverController presentPopoverFromRect:rcFrame
                                              inView:keyboardWindow
                            permittedArrowDirections:UIPopoverArrowDirectionUp
                                            animated:YES];
}

-(void) closeSignView {
    if (self.wePopoverController != nil && self.wePopoverController.popoverVisible) {
        [self.wePopoverController dismissPopoverAnimated:YES];
        self.wePopoverController = nil;
    }
}

#pragma mark SignViewDelegate
- (void) closeSign
{
    [self closeSignView];
}

- (void) saveSign:(UIImage *)imgSign
{
    [self closeSignView];
    
    CGRect visibleRect = [self.view convertRect:pageView.bounds toView:pageView];
    
    if(imgSign.size.width >300 || imgSign.size.height >300){
        imgSign =[imgSign scaleImageToSize:CGSizeMake(300,300)];
    }
    
    CGRect imageFrame = CGRectMake((visibleRect.origin.x < 0 ? 20 : visibleRect.origin.x + 20), (visibleRect.origin.y < 0 ? 100 : visibleRect.origin.y + 100), imgSign.size.width, imgSign.size.height);
    
    imageResizableView = [[SPUserResizableView alloc] initWithFrame:imageFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imgSign];
    imageResizableView.contentView = imageView;
    imageResizableView.delegate = self;
    [imageResizableView removeFromSuperview];
    [pageView addSubview:imageResizableView];
}

#pragma mark SPUserResizableViewDelegate

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    [imageResizableView hideEditingHandles];
    imageResizableView = userResizableView;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    imageResizableView = userResizableView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([imageResizableView hitTest:[touch locationInView:imageResizableView] withEvent:nil]) {
        return NO;
    }
    return YES;
}

#pragma mark util
- (CGFloat) calculateScale {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(screenRect.size.width <= 321){
            return 0.62;
        }else if(screenRect.size.width <= 375){
            return 0.75;
        }else {
            return 0.83;
        }
    } else {
        return 1.0;
    }
}

@end
