//
//  WTViewController.m
//  Wall Threw
//
//  Created by Robert Robinson on 10/02/2014.
//  Copyright (c) 2014 Robert Robinson. All rights reserved.
//

#import "WTViewController.h"


@interface WTViewController ()

@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	splashDelay=2;
    //get the screen height and width
    screenWidth=self.view.bounds.size.width;
    screenHeight=self.view.bounds.size.height;
    
    NSLog(@"width: %f, height: %f",screenWidth,screenHeight);
    
    //setup the audio player for the intro song
    NSString* introSoundFilePath = [[NSBundle mainBundle] pathForResource:@"mario" ofType:@"m4a"];
    NSURL *introSoundFileURL = [NSURL fileURLWithPath:introSoundFilePath];
    self.myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:introSoundFileURL error:nil];
    [self.myPlayer prepareToPlay];
    [self.myPlayer play];
    
    //show the loading screen
    CGRect frame=CGRectMake(0,0,screenHeight,screenWidth);
    self.splash = [[UIImageView alloc] initWithFrame:frame];
    [self.splash setImage:[UIImage imageNamed:@"splash.png"]];
    [self.view addSubview:self.splash];
    
    //set a time limit for the splash screen before loading the main menu
    self.timer = [NSTimer scheduledTimerWithTimeInterval:splashDelay target:self selector:@selector(loadMainMenu:) userInfo:nil repeats:NO];

    
}
//the handler for dealing with when the splash screen expires
- (void) loadMainMenu:(NSTimer*)timer
{
    //create our main menu view controller and 'present'it to the user
    WTMainGameView *mainGame=[[WTMainGameView alloc] init];
    mainGame.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:mainGame animated:YES completion:nil];
    
    //kill off the intro music
    [self.myPlayer stop];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
