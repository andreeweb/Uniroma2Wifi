//
//  UWAboutViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWAboutViewController.h"

@interface UWAboutViewController ()

@end

@implementation UWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)twitterButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=uniroma2wifi"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=uniroma2wifi"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/uniroma2wifi"]];
    
}

- (IBAction)facebookButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://profile/440789046053535"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/440789046053535"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://it-it.facebook.com/Uniroma2WiFi"]];
}

- (IBAction)gplusButtonAction:(id)sender {
    
    BOOL open = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"gplus://plus.google.com/106244358985510458585"]];
    
    if (open)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gplus://plus.google.com/106244358985510458585"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/106244358985510458585"]];
}

- (IBAction)visitWebSiteButtonAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.uniroma2wifi.it"]];
}

- (IBAction)sendEmailButtonAction:(id)sender {
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    [mailer setSubject:@"Uniroma2 Wi-FI - iOS"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"uniroma2wifi@gmail.com", nil];
    [mailer setToRecipients:toRecipients];
    
    [self presentViewController:mailer animated:YES completion:nil];
}

#pragma Email
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
