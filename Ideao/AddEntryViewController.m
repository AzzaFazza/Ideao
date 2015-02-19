//
//  AddEntryViewController.m
//  Ideao
//
//  Created by Adam Fallon on 19/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import "AddEntryViewController.h"
#import "Idea.h"

@interface AddEntryViewController ()

@end

@implementation AddEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    _ideaDescription.tag = 1;
    _ideaName.tag = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 50.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    return NO;
}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 50.0,
                                     self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark - CoreData Context
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - CoreData Save
- (IBAction)saveEntryAction:(id)sender {
    NSString *localIdeaText = _ideaName.text;
    NSString *localIdeaDescription = _ideaDescription.text;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *idea = [NSEntityDescription insertNewObjectForEntityForName:@"Idea" inManagedObjectContext:context];
    [idea setValue:localIdeaText forKey:@"ideaName"];
    [idea setValue:localIdeaDescription forKey:@"ideaDescription"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        NSLog(@"The Save Worked");
        NSLog(@"%@", idea);
    }
}

@end
