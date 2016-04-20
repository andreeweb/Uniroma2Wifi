//
//  UWTutorialController.h
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 14/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UWTextField.h"
#import "UWHomeViewController.h"
#import "AppDelegate.h"
#import "UWMacro.h"
#import "UWConditionsViewController.h"

@interface UWTutorialController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *tutorialViewStep1;
@property (weak, nonatomic) IBOutlet UIView *tutorialViewStep2;
@property (strong, nonatomic) IBOutlet UIView *tutorialViewStep3;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollTutorial;
@property (weak, nonatomic) IBOutlet UIPageControl *pageNumber;

@property (weak, nonatomic) IBOutlet UWTextField *matricolaTextField;
@property (weak, nonatomic) IBOutlet UWTextField *passwordTextField;

- (IBAction)buttonEndAction:(id)sender;
- (IBAction)readConditionAction:(id)sender;

//step3
@property (weak, nonatomic) IBOutlet UIImageView *logoImageTutorialStep3;
@property (weak, nonatomic) IBOutlet UILabel *textTopTutorialStep3;

//step1
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintContentImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintContentImage;
@end
