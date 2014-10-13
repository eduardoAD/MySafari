//
//  ViewController.m
//  MySafari
//
//  Created by Eduardo Alvarado Díaz on 10/12/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.urlTextField.text isEqual:@""]) {
        return NO;
    } else {
        NSString *urlText = self.urlTextField.text;
        if (![urlText containsString:@"http://"]) {
            urlText = [NSString stringWithFormat:@"http://%@",urlText];
        }
        NSURL *url = [[NSURL alloc] initWithString:urlText];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:urlRequest];
        [textField resignFirstResponder];

        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (IBAction)onStopButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}


- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}

- (void)updateButtons{
    self.forwardButton.enabled = self.webView.canGoForward;
    self.backButton.enabled = self.webView.canGoBack;
    self.stopButton.enabled = self.webView.loading;
}

- (IBAction)onPlusButtonPressed:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Coming soon!";
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}


@end
