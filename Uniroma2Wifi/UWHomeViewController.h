//
//  UWHomeViewController.h
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 03/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"
#import "TWMessageBarManager.h"
#import "KeychainItemWrapper.h"
#import "UWMacro.h"

@interface UWHomeViewController : UIViewController{
    
    NSMutableData *receivedData;
    NSURLConnection *testConnection;
    NSURLConnection *verifyConnection;
    NSURLConnection *connectToCaptive;
}


- (IBAction)doConnectionAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property (weak, nonatomic) IBOutlet UIView *socialView;

- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)facebookButtonAction:(id)sender;
- (IBAction)gplusButtonAction:(id)sender;

@end
