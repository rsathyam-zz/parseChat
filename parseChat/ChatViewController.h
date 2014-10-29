//
//  ChatViewController.h
//  parseChat
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
- (IBAction)onSendMessageClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@end
