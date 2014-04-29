//
//  MainViewController.h
//  MUW SIP Trainer
//
//  Created by Philipp König on 29.04.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIWebView *webViewCardBack;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerTag;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
