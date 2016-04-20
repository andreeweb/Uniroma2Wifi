//
//  UWSettingsTableViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 08/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWSettingsTableViewController.h"

@interface UWSettingsTableViewController ()

@end

@implementation UWSettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Sezioni
    tableSection    = [NSArray arrayWithObjects:@"Configurazioni", @"Supporto", @"Informazioni", nil];
    
    //Contenuto delle sezioni
    settings = @{@"Configurazioni"  :@[@"Credenziali"],
                 @"Supporto"        :@[@"Scrivi al supporto"],
                 @"Informazioni"    :@[@"Condizioni d'uso", @"Contatti"]};
    
    /*settingsImages = @{@"Configurazioni"  :@[@"key"],
                       @"Supporto"        :@[@"key"],
                       @"Informazioni"    :@[@"key", @"key"]};*/
    
    [self setTitle:@"Impostazioni"];
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
    
    /*UIImage *sectionImage   = [UIImage imageNamed:[[settingsImages objectForKey:sectionTitle]
                                                   objectAtIndex:indexPath.row]];*/
    
    // Configure the cell...
    //cell.imageView.image    = sectionImage;
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
                [self performSegueWithIdentifier:@"credentials_segue" sender:self];
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"support_segue" sender:self];
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"conditions_segue" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"contacts_segue" sender:self];
                break;
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
