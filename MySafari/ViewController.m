//
//  ViewController.m
//  MySafari
//
//  Created by Eduardo Alvarado Díaz on 10/12/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.urlTextField.text isEqual:@""]) {
        return NO;
    } else {
        NSURL *url = [[NSURL alloc] initWithString:self.urlTextField.text];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:urlRequest];
        [textField resignFirstResponder];
        
        return YES;
    }
}

@end
