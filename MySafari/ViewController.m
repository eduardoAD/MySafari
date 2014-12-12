//
//  ViewController.m
//  MySafari
//
//  Created by Eduardo Alvarado Díaz on 10/12/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) IBOutlet UIView *theView;

@property (strong, nonatomic) NSString *requestTXT;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.delegate = self;
    [self updateButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.urlTextField.text isEqual:@""]) {
        return NO;
    } else {
        [self goButtonPressed];
        [textField resignFirstResponder];
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
    self.navBar.title = @"Loading...";

    CGRect navBarFrame = self.theView.frame;
    navBarFrame.origin.y = 44;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.theView.frame = navBarFrame;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              self.theView.alpha = 1.0;
                                          }];
                     }];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    if (![webView.request.URL.absoluteString isEqualToString:@""] && ![webView.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        self.urlTextField.text = webView.request.URL.absoluteString;
    }
    self.navBar.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];

    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:@"<html><head><title>Error %li</title></head><body><center><font size=+1 color='red'><br><br><br>An error occurred:<br>%@</font></center></body></html>",error.code,error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
    self.urlTextField.text = self.requestTXT;
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

- (IBAction)onStatusButtonPressed:(UIButton *)sender{
    if ([self.webView isLoading]) {
        [self stopButtonPressed];
    }else{
        [self goButtonPressed];
    }
}

- (void)goButtonPressed {
    self.requestTXT = self.urlTextField.text;
    NSString *urlText = self.urlTextField.text;
    if (![urlText containsString:@"http://"]) {
        if (![urlText containsString:@"www."]) {
            urlText = [NSString stringWithFormat:@"www.%@",urlText];
        }
        urlText = [NSString stringWithFormat:@"http://%@",urlText];
    }
    NSURL *url = [[NSURL alloc] initWithString:urlText];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];

}

- (void)stopButtonPressed {
    [self.webView stopLoading];
}


- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}

- (void)updateButtons{
    self.forwardButton.enabled = self.webView.canGoForward;
    if([self.forwardButton isEnabled]){
        self.forwardButton.imageView.image = [UIImage imageNamed:@"next-24"];
    }else{
        self.forwardButton.imageView.image = [UIImage imageNamed:@"next-24-1"];
    }

    self.backButton.enabled = self.webView.canGoBack;
    if([self.backButton isEnabled]){
        self.backButton.imageView.image = [UIImage imageNamed:@"previous-24"];
    }else{
        self.backButton.imageView.image = [UIImage imageNamed:@"previous-24-1"];
    }

    if ([self.webView isLoading]) {
        self.statusButton.imageView.image = [UIImage imageNamed:@"close-25"];
    }else{
        self.statusButton.imageView.image = [UIImage imageNamed:@"redo-25"];
    }
}

- (IBAction)onPlusButtonPressed:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"Coming soon!";
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}


#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    float contentHeight = scrollView.contentSize.height;
    float height = scrollView.frame.size.height;
    float offset = scrollView.contentOffset.y;

    if (offset >= 0.0 && (height+offset<=contentHeight)) {
        float porcent = 100-((offset*100)/(contentHeight-height));

        CGRect navBarFrame = self.theView.frame;
        navBarFrame.origin.y = 44;

        CGRect webViewFrame = self.webView.frame;
        webViewFrame.origin.y = 82;

        if (porcent >=75.0) {
            float delta = (porcent-75.0)/25.0;
            //NSLog(@"%.2f, %.2f", porcent, delta);
            self.theView.alpha = delta;

            navBarFrame.origin.y = (44 * delta);
            self.theView.frame = navBarFrame;

            webViewFrame.origin.y = (38 * delta) + 44;
            //webViewFrame.size.height = (44 * delta) + height;
            self.webView.frame = webViewFrame;
        }
        
    }

}

@end
