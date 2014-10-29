//
//  LoginViewController.m
//  parseChat
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (nonatomic, weak) PFUser *user;
- (void)successfulLogin:(PFUser *)user;
- (IBAction)passwordEnterComplete:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.passwordTextField.secureTextEntry = YES;
    
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
- (IBAction)signInClicked:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful login! - %@", user);
                                            [self successfulLogin:user];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Login failed!");
                                        }
                                    }];
}

- (IBAction)signUpClicked:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
  /*
    user.username = @"my name";
    user.password = @"my pass";
    user.email = @"email@example.com";
        
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    */
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Successful! %@", user);
            [self successfulLogin:user];
                // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"%@", errorString);
        }
        }];
}

- (void)successfulLogin:(PFUser *)user {
    NSLog(@"successful login!");
    ChatViewController *vc = [[ChatViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)passwordEnterComplete:(id)sender {
    [self signInClicked:sender];
}

@end
