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
#import <UIColor+FlatUI.h>

@interface HomeViewController () {
    User * user;
}

@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;
@property (nonatomic) NSUInteger colorIndex;
@property (nonatomic) BOOL loadCardFromXib;
@property (nonatomic, strong) NSArray *colors;
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
   self.swipeableView.delegate = self;    
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
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

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
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

#pragma mark - Action

- (IBAction)swipeLeftButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)swipeRightButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToRight];
}
- (IBAction)swipeUpButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToUp];
}
- (IBAction)swipeDownButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToDown];
}

- (IBAction)reloadButtonAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Load Cards"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Programmatically", @"From Xib", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.loadCardFromXib = buttonIndex == 1;
    
    self.colorIndex = 0;
    
    [self.swipeableView discardAllSwipeableViews];
    [self.swipeableView loadNextSwipeableViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex < self.colors.count) {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.backgroundColor = [self colorForName:self.colors[self.colorIndex]];
        self.colorIndex++;
        
        if (self.loadCardFromXib) {
            UIView *contentView =
            [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                           owner:self
                                         options:nil] objectAtIndex:0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:contentView];
            
            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            NSDictionary *metrics = @{
                                      @"height" : @(view.bounds.size.height),
                                      @"width" : @(view.bounds.size.width)
                                      };
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
            [view addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[contentView(width)]"
              options:0
              metrics:metrics
              views:views]];
            [view addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:
                                  @"V:|[contentView(height)]"
                                  options:0
                                  metrics:metrics
                                  views:views]];
        } else {
            UITextView *textView =
            [[UITextView alloc] initWithFrame:view.bounds];
            textView.text = @"This UITextView was created programmatically.";
            textView.backgroundColor = [UIColor clearColor];
            textView.font = [UIFont systemFontOfSize:24];
            textView.editable = NO;
            textView.selectable = NO;
            [view addSubview:textView];
        }
        
        return view;
    }
    return nil;
}

#pragma mark - ()

- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName =
    [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
    [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}

@end
