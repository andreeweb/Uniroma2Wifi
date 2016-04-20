//
//  UWConditionsViewController.m
//  Uniroma2Wifi
//
//  Created by Andrea Cerra on 16/11/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UWConditionsViewController.h"

@interface UWConditionsViewController ()

@end

@implementation UWConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //bug fix
    [[self textViewConditions] setContentOffset:CGPointMake(0, -50)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
