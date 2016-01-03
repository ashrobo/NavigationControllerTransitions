//
//  ModalViewController.m
//  ViewControllerTransitions
//
//  Created by Ash Robinson on 03/01/2016.
//  Copyright © 2016 Example. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@end

@implementation ModalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) self.dismissButton.hidden = YES;
}

- (IBAction)dismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
