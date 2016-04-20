//
//  UWTutorialController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWTutorialController.h"

@interface UWTutorialController ()

@end

@implementation UWTutorialController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Tutorial"];
    
    //load tutorial view
    [[NSBundle mainBundle] loadNibNamed:@"UWTutorialViewStep1" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"UWTutorialViewStep2" owner:self options:nil];
    [[NSBundle mainBundle] loadNibNamed:@"UWTutorialViewStep3" owner:self options:nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [_tutorialViewStep1 setFrame:CGRectMake(0, 0,
                                           self.tutorialViewStep1.frame.size.width,
                                           self.tutorialViewStep1.frame.size.height)];
    
    [_tutorialViewStep2 setFrame:CGRectMake(screenRect.size.width, 0,
                                           self.tutorialViewStep2.frame.size.width,
                                           self.tutorialViewStep2.frame.size.height)];
    
    [_tutorialViewStep3 setFrame:CGRectMake(screenRect.size.width*2, 0,
                                           self.tutorialViewStep3.frame.size.width,
                                           self.tutorialViewStep3.frame.size.height)];
    
    [_scrollTutorial addSubview:_tutorialViewStep1];
    [_scrollTutorial addSubview:_tutorialViewStep2];
    [_scrollTutorial addSubview:_tutorialViewStep3];
    
    
    [_scrollTutorial setContentSize:CGSizeMake(screenRect.size.width*3, 0)];
    
    //modifiche layout su iPhone 4
    if(IS_IPHONE_4_AND_OLDER){
        
        //### STEP1
        
        [_topConstraintContentImage setConstant:20.0];
        [_bottomConstraintContentImage setConstant:20.0];
        
        //#### STEP3
        
        //rimuovo il logo nello step 3
        [_logoImageTutorialStep3 removeFromSuperview];
        
        //reimposto le constraint
        NSLayoutConstraint *bottomSpaceConstraint = [NSLayoutConstraint constraintWithItem:_textTopTutorialStep3
                                                                                 attribute:NSLayoutAttributeTop
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeTop
                                                                                multiplier:1.0
                                                                                  constant:50.0];
        [self.view addConstraint:bottomSpaceConstraint];
        [self.view layoutIfNeeded];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    float fractionalPage = scrollView.contentOffset.x / screenRect.size.width;
    NSInteger page = lround(fractionalPage);
    [_pageNumber setCurrentPage:page];
}

- (IBAction)buttonEndAction:(id)sender {
    
    //imposto tutorial fatto
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_access"];
    
    //per il team review
    BOOL apple_access = ([_matricolaTextField.text isEqualToString:@"0000001"] && [_passwordTextField.text isEqualToString:@"0000001"]) ? YES : NO;
    
    //condizione di inserimento campi
    BOOL check_insert = ([self textFieldHasText:_matricolaTextField] && [self textFieldHasText:_passwordTextField]) ? YES : NO;
    
    if(apple_access || check_insert){
    
        //salvo le credenziali
        //all'azione del tasto back recupero le info dalla riga e le salvo
        NSString *matricola = _matricolaTextField.text;
        NSString *password = _passwordTextField.text;
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UniWifi" accessGroup:nil];
        [wrapper resetKeychainItem];
        [wrapper setObject:matricola forKey:(__bridge id)kSecAttrAccount];
        [wrapper setObject:password forKey:(__bridge id)kSecValueData];
        
        //vado in home
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle: nil];
        
        //cambio il root controller
        UWHomeViewController *homeController = (UWHomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController *currentController = delegate.window.rootViewController;
        delegate.window.rootViewController = homeController;
        delegate.window.rootViewController = currentController;
        
        [UIView transitionWithView:delegate.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            delegate.window.rootViewController = homeController;
                            
                        }
                        completion:nil];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione"
                                                        message:@"Per poterti collegare alla rete tramite questa applicazione è necessario inserire le tue credenziali. Grazie"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

- (IBAction)readConditionAction:(id)sender {
    
    //vado in home
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"bundle: nil];
    
    UWConditionsViewController *conditionController = (UWConditionsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Conditions"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:conditionController];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissController)];
    conditionController.navigationItem.rightBarButtonItem = closeButton;
    
    //now present this navigation controller modally
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) dismissController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//remove white spaces and check if textfield has text
-(BOOL) textFieldHasText:(UITextField*)textfield {
    
    NSString *t1= [textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([t1 length] > 0)
        return true;
    else
        return false;
}

-  (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _passwordTextField) {
        
        if (IS_IPHONE_5) {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [[self view]setFrame:CGRectMake(self.view.frame.origin.x,
                                                                 self.view.frame.origin.y - 50,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 // whatever you need to do when animations are complete
                             }];
        }
    }
}

//hanlde return / next button
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _matricolaTextField) {
        [_passwordTextField becomeFirstResponder];
    }else if (textField == _passwordTextField){
        
        if (IS_IPHONE_5) {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [[self view]setFrame:CGRectMake(self.view.frame.origin.x,
                                                                 self.view.frame.origin.y + 50,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                                 // whatever you need to do when animations are complete
                             }];
        }
        
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
