//
//  AddEntryViewController.h
//  Ideao
//
//  Created by Adam Fallon on 19/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ideaName;
@property (weak, nonatomic) IBOutlet UITextField *ideaDescription;
@property (weak, nonatomic) IBOutlet UIButton *saveEntry;

- (IBAction)saveEntryAction:(id)sender;

@end
