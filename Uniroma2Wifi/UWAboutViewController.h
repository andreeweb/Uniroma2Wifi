//
//  UWAboutViewController.h
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UWAboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)facebookButtonAction:(id)sender;
- (IBAction)gplusButtonAction:(id)sender;
- (IBAction)visitWebSiteButtonAction:(id)sender;
- (IBAction)sendEmailButtonAction:(id)sender;

@end
