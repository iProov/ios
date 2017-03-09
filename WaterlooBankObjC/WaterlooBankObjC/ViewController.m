//
//  ViewController.m
//  WaterlooBankObjC
//
//  Created by Jonathan Ellis on 05/07/2015.
//  Copyright (c) 2015 iProov Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import <iProov/iProov-Swift.h>

#define WB_SERVICE_PROVIDER @"a73e90cf90e3ede70fd38639ef621f072aca8364"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Waterloo Bank (ObjC)";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:nil action: nil];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if (self.usernameTextField.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your username/email to login." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self login:self.usernameTextField.text];

}

- (void)login:(NSString *)username {
    
    [IProov verifyWithServiceProvider:WB_SERVICE_PROVIDER
                             username:username
                             animated:YES
                              success:^(NSString * _Nonnull token) {
                                  [self performSegueWithIdentifier:@"ShowMain" sender:token];
                                  self.usernameTextField.text = nil;
                              
                              } failure:^(NSString * _Nonnull reason) {
                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed" message:reason preferredStyle:UIAlertControllerStyleAlert];
                                  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                  [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                      [self login:username];
                                  }]];
                                  
                                  [self presentViewController:alert animated:YES completion:nil];
                              
                              } error:^(NSError * _Nonnull error) {
                                  
                                  if (error.code == IProovErrorCodeUserPressedBack || error.code == IProovErrorCodeUserPressedHome) { // Ignore cases where the user voluntarily pressed the back button
                                      return;
                                  }
                                  
                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                  [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                      [self login:username];
                                  }]];
                                  [self presentViewController:alert animated:YES completion:nil];
                              }];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    
    if (self.usernameTextField.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your username/email to register." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self registerUser:self.usernameTextField.text];
    
}

- (void)registerUser:(NSString *)username {

    [IProov enrolWithServiceProvider:WB_SERVICE_PROVIDER
                            username:username
                            animated:YES
                             success:^(NSString * _Nonnull token) {
                                 [self performSegueWithIdentifier:@"ShowMain" sender:token];
                                 self.usernameTextField.text = nil;
                                                 
                            } failure:^(NSString * _Nonnull reason) {
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration failed" message:reason preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [self registerUser:username];
                                }]];
                                                 
                                [self presentViewController:alert animated:YES completion:nil];
                                                 
                            } error:^(NSError * _Nonnull error) {
                                                 
                                 if (error.code == IProovErrorCodeUserPressedBack || error.code == IProovErrorCodeUserPressedHome) { // Ignore cases where the user voluntarily pressed the back button
                                     return;
                                 }
                                 
                                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration failed" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                 [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                                 [alert addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                     [self registerUser:username];
                                 }]];
                                 [self presentViewController:alert animated:YES completion:nil];
                             }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowMain"]) {
        
        MainViewController *mainViewController = segue.destinationViewController;
        
        mainViewController.token = sender;
    }
    
}

@end
