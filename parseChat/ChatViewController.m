//
//  ChatViewController.m
//  parseChat
//
//  Created by Ravi Sathyam on 10/29/14.
//  Copyright (c) 2014 SambarLabs. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import <Parse/Parse.h>

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* messages;
- (void)fetchMessages;
@end

@implementation ChatViewController

- (void)fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu messages.", (unsigned long)objects.count);
            // Do something with the found objects
            self.messages = objects;
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.chatTableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    [self.chatTableView registerNib:[UINib nibWithNibName:@"ChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatTableViewCell"];
    
    // Do any additional setup after loading the view from its nib.
    [self fetchMessages];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(fetchMessages) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell* cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"ChatTableViewCell"];
    PFObject* message = self.messages[indexPath.row];
    cell.messageLabel.text = message[@"text"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)onSendMessageClicked:(id)sender {
    NSString *message = self.messageTextField.text;
    NSLog(@"Sending message: %@", message);
    PFObject *messagePFO = [PFObject objectWithClassName:@"Message"];
    messagePFO[@"text"] = message;
    [messagePFO saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully sent message: %@", message);
            [self fetchMessages];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}
@end
