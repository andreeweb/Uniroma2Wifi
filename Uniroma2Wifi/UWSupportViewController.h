//
//  UWSupportViewController.h
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <sys/utsname.h>

@interface UWSupportViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    
    NSArray *tableSection;
    NSDictionary *settings;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end
