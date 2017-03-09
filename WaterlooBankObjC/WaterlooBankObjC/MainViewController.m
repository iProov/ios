//
//  MainViewController.m
//  WaterlooBankObjC
//
//  Created by Jonathan Ellis on 05/07/2015.
//  Copyright (c) 2015 iProov Ltd. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tokenLabel;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Your Account";
    
    self.tokenLabel.text = [NSString stringWithFormat:@"Your token is %@", self.token];
}



@end
