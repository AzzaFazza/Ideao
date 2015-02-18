//
//  ViewController.h
//  Ideao
//
//  Created by Adam Fallon on 18/02/2015.
//  Copyright (c) 2015 com.adamf.ideao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import <MoPub/MPAdView.h>


@interface LoginViewController : UIViewController <MPAdViewDelegate>

@property (nonatomic, retain) MPAdView *adView;


@end

