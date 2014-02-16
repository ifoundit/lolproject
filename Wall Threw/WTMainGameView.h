//
//  WTMainGameView.h
//  Wall Threw
//
//  Created by Robert Robinson on 10/02/2014.
//  Copyright (c) 2014 Robert Robinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GADBannerView.h"

@class GADBannerView;
@class GADRequest;



@interface WTMainGameView : UIViewController <GADBannerViewDelegate>
{
    UITapGestureRecognizer *mainTapRecognizer;
    int framecounter;
    int frametrigger;
    float bannerStartPoint;
    UITapGestureRecognizer *clickScoreBoard;
    float fishVerticalSpeed;
    float horizontalSpeed;
    float tapspeed,gapsize;
    float fishBottom;
    int fishFrame;
    int fishFrameDelay;
    bool fishFrameForwards;
    float gravity;
    float difficulty;
    float scoreBoardYTarg;
    bool started;
    bool crashed;
    bool showScore;
    int thisscore;
    NSArray *fishImages;
    bool passedPipe1,passedPipe2,passedPipe3;
    
    float pipe1x,pipe1yt,pipe1yb;
    float pipe2x,pipe2yt,pipe2yb;
    float pipe3x,pipe3yt,pipe3yb;
    
    float groundx,groundy,ground2x,ground2y;
    
}

//ads propeties
@property(nonatomic, strong) GADBannerView *adBanner;
//overide request ads
- (GADRequest *)request;


@property (strong, nonatomic) IBOutlet UIImageView *pipe1_top;
@property (strong, nonatomic) IBOutlet UIImageView *pipe1_bottom;
@property (strong, nonatomic) IBOutlet UIImageView *pipe2_top;
@property (strong, nonatomic) IBOutlet UIImageView *pipe2_bottom;
@property (strong, nonatomic) IBOutlet UIImageView *pipe3_top;
@property (strong, nonatomic) IBOutlet UIImageView *pipe3_bottom;

@property (strong, nonatomic) IBOutlet UIImageView *fish;
@property (strong, nonatomic) IBOutlet UIImageView *ground1;
@property (strong, nonatomic) IBOutlet UIImageView *ground2;
@property (strong, nonatomic) IBOutlet UIImageView *block;

@property (strong, nonatomic) IBOutlet UIImageView *scoreboard;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

- (id)init;
- (void)viewDidLoad;
- (void) doFrame;
- (float)getRandomY: (float) difficulty;
- (void) screenTapReceiver:(UITapGestureRecognizer *)sender;
- (void) restartGame;
- (void) setFishFrame;
- (void)didReceiveMemoryWarning;

@end
