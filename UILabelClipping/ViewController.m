//
//  ViewController.m
//  UILabelClipping
//
//  Created by Amar Kulo on 29/11/15.
//  Copyright © 2015 Amar Kulo. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation ViewController

@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    label.font = [UIFont fontWithName:@"Stanislav" size:100];
    [self updateLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonDown:(UIButton *)button {
    
    switch (button.tag) {
        case 1:
            // SignPainter
            label.font = [UIFont fontWithName:@"SignPainter" size:100];
            break;
        case 2:
            // Stanislav
            label.font = [UIFont fontWithName:@"Stanislav" size:100];
            break;
        case 3:
            // Strato
            label.font = [UIFont fontWithName:@"Strato-linked" size:100];
            break;
        default:
            break;
    }
    
    [self updateLabel];
    
}


- (void)updateLabel {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName:label.font, NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    CGRect calculatedRect = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)  options:(NSStringDrawingUsesLineFragmentOrigin) context:nil];
    
    NSLog(@"NSAttributedString boundingRectWithSize:options:context: %@", NSStringFromCGRect(calculatedRect));
    
    CGSize attributedSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font, NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSLog(@"NSString sizeWithAttributes: %@", NSStringFromCGSize(attributedSize));
    
    CGRect textViewRect;
    
    @autoreleasepool {
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX)];
        textView.text = label.text;
        textView.font = label.font;
        textView.textContainerInset = UIEdgeInsetsZero;
        CGSize size= [textView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        NSLog(@"UITextView sizeThatFits: %@", NSStringFromCGSize(size));
        
        [textView sizeToFit];
        
        NSLog(@"UITextView after sizeToFit: %@", NSStringFromCGSize(textView.frame.size));
        
        CGFloat padding = textView.textContainer.lineFragmentPadding;
        CGFloat actualPageWidth = size.width - padding * 2;
        
        NSLog(@"UITextView pageWidth: %f", actualPageWidth);
        
        textViewRect = CGRectMake(0, 0, size.width, size.height);
        textView = nil;
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
        CGSize targetSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [attributedString length]), NULL, targetSize, NULL);
        NSLog(@"CTFramesetterSuggestedFrameSizeWithConstraints: %@", NSStringFromCGSize(fitSize));
        CFRelease(framesetter);
        
    }
    
    CGPoint labelCenter = label.center;
    label.frame = calculatedRect;
    label.center = labelCenter;
    
}


@end
