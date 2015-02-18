//
//  HomeViewController.m
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "User.h"

@interface HomeViewController () {
    User * user;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"User" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *descriptor1 = [[NSSortDescriptor alloc]
                                        initWithKey:@"phoneNumber" ascending:YES];
    NSSortDescriptor *descriptor2 = [[NSSortDescriptor alloc]
                                     initWithKey:@"userID" ascending:YES];
    NSArray *sortDescriptors = @[descriptor1, descriptor2];
    
    request.sortDescriptors = sortDescriptors;
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil) {
       //Handle ALERT
    } else {
        user = [array objectAtIndex:0];
        NSLog(@"%@", user);
        NSString *phoneNumber = [NSString stringWithFormat: @"Logged in with UserID: %@ Number: %@", user.userID, user.phoneNumber];
        self.loggedInInfoLabel.text = phoneNumber;
    }
    
    // TODO: Replace this test id with your personal ad unit id
    MPAdView* adView = [[MPAdView alloc] initWithAdUnitId:@"0fd404de447942edb7610228cb412614"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


@end
