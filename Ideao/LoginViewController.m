//
//  ViewController.m
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController () {
    NSString *localPhoneNumber;
    NSString *localUserID;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        
        if (session.phoneNumber != nil) {
            localPhoneNumber = [[NSString alloc] initWithString:session.phoneNumber];
            localUserID = [[NSString alloc] initWithString:session.userID];
            [self performSegueWithIdentifier:@"loginToHome" sender:self];
            [self saveUserToCoreData];
        }
        
    }];
    
    authenticateButton.center = self.view.center;
    [self.view addSubview:authenticateButton];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self sessionHandler];
    
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

- (void)saveUserToCoreData {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *user= [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [user setValue:localPhoneNumber forKey:@"phoneNumber"];
    [user setValue:localUserID forKey:@"userID"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    } else {
        NSLog(@"The Save Worked");
    }
}

- (void)sessionHandler {
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
        //Do Nothing
    } else {
        [self performSegueWithIdentifier:@"loginToHome" sender:self];
    }

}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

@end
