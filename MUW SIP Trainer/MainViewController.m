//
//  MainViewController.m
//  MUW SIP Trainer
//
//  Created by Philipp König on 29.04.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import "MainViewController.h"
#import "Deck.h"

NSString * const keyHideAnswer = @"keyHideAnswer";

@interface MainViewController ()

- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)showAnswer:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowAnswer;

@end

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [swipeRecognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:swipeRecognizerLeft];
    
    UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [swipeRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:swipeRecognizerRight];
    
    [[Deck getInstance] loadData];
    
    [[_webView scrollView] setBounces:NO];
    [[_webViewCardBack scrollView] setBounces:NO];
}

-(void) viewDidAppear:(BOOL)animated {
    [self setCard];
    [self handleHideAnswer];
}

-(void) handleHideAnswer {
    bool hideAnswer = [[NSUserDefaults standardUserDefaults]
                       boolForKey:keyHideAnswer];
    
    // hide/show answer button
    if(hideAnswer) {
        [_buttonShowAnswer setHidden:NO];
        [_webViewCardBack setHidden:YES];
    } else {
        [_buttonShowAnswer setHidden:YES];
        [_webViewCardBack setHidden:NO];
    }
}

-(void)setCard {
    // set label cards i.e. 5 / 433
    NSMutableString *cardOfCards = [[NSMutableString alloc] initWithString:@""];
    [cardOfCards appendFormat:@"%d", (int)[Deck getInstance].currentCardIndex + 1];
    [cardOfCards appendString:@" / "];
    [cardOfCards appendFormat:@"%d", (int)[Deck getInstance].cardMax];
    [_label setText:cardOfCards];
    
    Card *card = [[Deck getInstance] getCardForIndex:[Deck getInstance].currentCardIndex inCategory:[Deck getInstance].currentTag];
    
    // get base url for images
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    documentDirectory = [documentDirectory stringByAppendingString:@"/deck"];
    NSURL *url = [NSURL fileURLWithPath:documentDirectory];
    
    //set more readable font than the default webview font
    NSString *front = [NSString stringWithFormat:@"<style type='text/css'>img { max-width: 100%%; width: auto; height: auto; }</style><font face='Sans-Serif' size='3'>%@", card.front];
    NSString *back = [NSString stringWithFormat:@"<style type='text/css'>img { max-width: 100%%; width: auto; height: auto; }</style><font face='Sans-Serif' size='3'>%@", card.back];
    
    [_webView loadHTMLString:front baseURL:url];
    [_webViewCardBack loadHTMLString:back baseURL:url];
    
    [self handleHideAnswer];
}

-(void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)recognizer {
    [[Deck getInstance] setNextCard];
    [self setCard];
}

-(void)handleSwipeFromRight:(UISwipeGestureRecognizer *)recognizer {
    [[Deck getInstance] setPreviousCard];
    [self setCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (IBAction)previous:(id)sender {
    [self handleSwipeFromRight:nil];
}

- (IBAction)next:(id)sender {
    [self handleSwipeFromLeft:nil];
}

- (IBAction)showAnswer:(id)sender {
    [_webViewCardBack setHidden:NO];
}
@end
