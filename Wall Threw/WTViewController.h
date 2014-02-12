//
//  WTViewController.h
//  Wall Threw
//
//  Created by Robert Robinson on 10/02/2014.
//  Copyright (c) 2014 Robert Robinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTMainGameView.h"
#import "AVFoundation/AVFoundation.h"
#import <QuartzCore/QuartzCore.h>

@interface WTViewController : UIViewController
{
    float screenWidth,screenHeight;
    int splashDelay;
}

@property (strong, nonatomic) AVAudioPlayer *myPlayer;
@property (strong, nonatomic) IBOutlet UIImageView *splash;
@property (strong, nonatomic) NSTimer *timer;

@end
