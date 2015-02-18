//
//  HomeViewController.h
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <MoPub/MPAdView.h>

@interface HomeViewController : UIViewController <MPAdViewDelegate>

@property (nonatomic, retain) MPAdView *adView;

@property (weak, nonatomic) IBOutlet UILabel *loggedInInfoLabel;

@end
