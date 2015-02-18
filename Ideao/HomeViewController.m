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
#import "CardView.h"

@interface HomeViewController () {
    User * user;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self coreDataFetch];
    [self setupAds];
    [self setUpSwipeView];
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

- (void)setUpSwipeView {
    _swipeableView = [[ZLSwipeableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_swipeableView];
    
    self.colorIndex = 0;
    self.colors = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];
    
    // Optional Delegate
    _swipeableView.delegate = self;

    
    
}

#pragma mark - Ads
-(void)setupAds {
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

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    return [[UIView alloc] init];
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

#pragma mark - ZLSwipeableViewDelegate
- (void)swipeableView:(ZLSwipeableView *)swipeableView
           didSwipeUp:(UIView *)view {
    NSLog(@"did swipe up");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeDown:(UIView *)view {
    NSLog(@"did swipe down");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didStartSwipingView:(UIView *)view atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location  translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
}
- (void)swipeableView:(ZLSwipeableView *)swipeableView didEndSwipingView:(UIView *)view atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y%f", location.x, location.y);
}

#pragma mark - CoreData Fetch

- (void)coreDataFetch {
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
}


@end
