//
//  UWSettingsTableViewController.h
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 08/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UWCredenzialiTableViewController.h"

@interface UWSettingsTableViewController : UITableViewController{

    NSArray *tableSection;
    
    NSDictionary *settings;
    //NSDictionary *settingsImages;
}

@end
