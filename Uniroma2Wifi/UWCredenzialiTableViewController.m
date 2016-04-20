//
//  UWCredenzialiTableViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 11/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWCredenzialiTableViewController.h"

@interface UWCredenzialiTableViewController ()

@end

@implementation UWCredenzialiTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //titolo vista
    [self setTitle:@"Credenziali"];
}

- (void) viewDidDisappear:(BOOL)animated
{
    //all'azione del tasto back recupero le info dalla riga e le salvo
    NSIndexPath *indexMatricola = [NSIndexPath indexPathForRow:0 inSection:0];
    UWCredentialsTableViewCell *m = (UWCredentialsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexMatricola];
    NSString *matricola = m.cellText.text;
        
    NSIndexPath *indexPassword = [NSIndexPath indexPathForRow:1 inSection:0];
    UWCredentialsTableViewCell *p = (UWCredentialsTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPassword];
    NSString *password = p.cellText.text;
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UniWifi" accessGroup:nil];
    [wrapper resetKeychainItem];
    [wrapper setObject:matricola forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:password forKey:(__bridge id)kSecValueData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"credentials_cell";
    UWCredentialsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UWCredentialsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UniWifi" accessGroup:nil];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        
        [cell.cellLabel setText:@"Matricola"];
        [cell.cellText setReturnKeyType:UIReturnKeyNext];
        [cell.cellText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [cell.cellText setTag:99];
        [cell.cellText setPlaceholder:@"Inserisci matricola"];
        [cell.cellText setText:[wrapper objectForKey:(__bridge id)(kSecAttrAccount)]];
        
    }else{
        
        cell.cellLabel.text = @"Password";
        [cell.cellText setSecureTextEntry:YES];
        [cell.cellText setReturnKeyType:UIReturnKeyDone];
        [cell.cellText setTag:100];
        [cell.cellText setPlaceholder:@"Inserisci password"];
        [cell.cellText setText:[wrapper objectForKey:(__bridge id)(kSecValueData)]];
    }
    
    return cell;
}

//hanlde return / next button
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
