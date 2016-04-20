//
//  UWSupportViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWSupportViewController.h"

@interface UWSupportViewController ()

@end

@implementation UWSupportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Sezioni
    tableSection    = [NSArray arrayWithObjects:@"Supporto Applicazione", @"Supporto rete Uniroma2", nil];
    
    //Contenuto delle sezioni
    settings = @{@"Supporto Applicazione"   :@[@"Scrivi agli sviluppatori", @"Invia un tweet"],
                 @"Supporto rete Uniroma2"  :@[@"Scrivi al supporto per la rete"],};
    
    //imposto i margini all'itenrno della textview
    //[_infoTextView  setTextContainerInset:UIEdgeInsetsMake(0, 50, 0, 50)];
    
    //imposto lo sfondo della vista come quello della tabella
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //titolo vista
    [self setTitle:@"Supporto"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableSection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tableSection objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle  = [tableSection objectAtIndex:section];
    NSArray *sectionValues  = [settings objectForKey:sectionTitle];
    
    return [sectionValues count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *sectionTitle  = [tableSection objectAtIndex:indexPath.section];
    NSArray *sectionValues  = [settings objectForKey:sectionTitle];
    
    cell.textLabel.text     = [sectionValues objectAtIndex:indexPath.row];
    cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [self sendEmailTo:@"uniroma2wifi@gmail.com"];
                break;
            case 1:
                [self writeTweet];
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self sendEmailTo:@"wifi@supporto.uniroma2.it"];
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma Twitter
- (void) sendEmailTo :(NSString*) destination {
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    
    mailer.mailComposeDelegate = self;
    
    [mailer setSubject:@"Uniroma2 Wi-FI - Supporto iOS"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:destination, nil];
    [mailer setToRecipients:toRecipients];
    
    NSString *emailBody = [[NSString alloc] initWithFormat:@"\n \n \n \n \n ### \n iOS Version: %@ \n App Version: %@ \n Device: %@ \n ###",
                           [[UIDevice currentDevice] systemVersion],
                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                           [self deviceModelName]];
    
    [mailer setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailer animated:YES completion:nil];
}

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

# pragma Twitter
- (void) writeTweet {
        
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Hey! @uniroma2wifi"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

#pragma Methods
- (NSString*)deviceModelName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //MARK: More official list is at
    //http://theiphonewiki.com/wiki/Models
    //MARK: You may just return machineName. Following is for convenience
    
    NSDictionary *commonNamesDictionary =
    @{
      @"i386":     @"iPhone Simulator",
      @"x86_64":   @"iPad Simulator",
      
      @"iPhone1,1":    @"iPhone",
      @"iPhone1,2":    @"iPhone 3G",
      @"iPhone2,1":    @"iPhone 3GS",
      @"iPhone3,1":    @"iPhone 4",
      @"iPhone3,2":    @"iPhone 4(Rev A)",
      @"iPhone3,3":    @"iPhone 4(CDMA)",
      @"iPhone4,1":    @"iPhone 4S",
      @"iPhone5,1":    @"iPhone 5(GSM)",
      @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
      @"iPhone5,3":    @"iPhone 5c(GSM)",
      @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
      @"iPhone6,1":    @"iPhone 5s(GSM)",
      @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",
      
      @"iPhone7,1":    @"iPhone 6+ (GSM+CDMA)",
      @"iPhone7,2":    @"iPhone 6 (GSM+CDMA)",
      
      @"iPad1,1":  @"iPad",
      @"iPad2,1":  @"iPad 2(WiFi)",
      @"iPad2,2":  @"iPad 2(GSM)",
      @"iPad2,3":  @"iPad 2(CDMA)",
      @"iPad2,4":  @"iPad 2(WiFi Rev A)",
      @"iPad2,5":  @"iPad Mini 1G (WiFi)",
      @"iPad2,6":  @"iPad Mini 1G (GSM)",
      @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
      @"iPad3,1":  @"iPad 3(WiFi)",
      @"iPad3,2":  @"iPad 3(GSM+CDMA)",
      @"iPad3,3":  @"iPad 3(GSM)",
      @"iPad3,4":  @"iPad 4(WiFi)",
      @"iPad3,5":  @"iPad 4(GSM)",
      @"iPad3,6":  @"iPad 4(GSM+CDMA)",
      
      @"iPad4,1":  @"iPad Air(WiFi)",
      @"iPad4,2":  @"iPad Air(GSM)",
      @"iPad4,3":  @"iPad Air(GSM+CDMA)",
      
      @"iPad4,4":  @"iPad Mini 2G (WiFi)",
      @"iPad4,5":  @"iPad Mini 2G (GSM)",
      @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",
      
      @"iPod1,1":  @"iPod 1st Gen",
      @"iPod2,1":  @"iPod 2nd Gen",
      @"iPod3,1":  @"iPod 3rd Gen",
      @"iPod4,1":  @"iPod 4th Gen",
      @"iPod5,1":  @"iPod 5th Gen",
      
      };
    
    NSString *deviceName = commonNamesDictionary[machineName];
    
    if (deviceName == nil) {
        deviceName = machineName;
    }
    
    return deviceName;
}


@end
