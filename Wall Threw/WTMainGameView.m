//
//  WTMainGameView.m
//  Wall Threw
//
//  Created by Robert Robinson on 10/02/2014.
//  Copyright (c) 2014 Robert Robinson. All rights reserved.
//

#import "WTMainGameView.h"
#import "GADBannerView.h"
#import "GADRequest.h"


@interface WTMainGameView ()

@end

@implementation WTMainGameView

//ads display flag: TRUE ads should be display, FALSE ads is already display;
BOOL startAds = TRUE;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor cyanColor];
    
    //create a timer event to trigger per frame events, for the animations
    [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(doFrame) userInfo:nil repeats:YES];
    
    //add the tap recognizer for the screen
    mainTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapReceiver:)];
    [self.view addGestureRecognizer:mainTapRecognizer];
    [self.view setUserInteractionEnabled:YES];
    
    framecounter=0;
    frametrigger=200;
    bannerStartPoint=100;
    gravity=0.35;
    birdVerticalSpeed=0;
    tapspeed=-7;
    birdBottom=406;
    
    started=NO;
    showScore=NO;
    crashed=NO;
    passedPipe1=NO;
    passedPipe2=NO;
    passedPipe3=NO;
    groundx=0;
    scoreBoardYTarg=100;
    ground2x=320;
    groundy=428;
    ground2y=428;
    thisscore=0;
    horizontalSpeed=3;
    difficulty=0;
    gapsize=120;
    
    //make starting positions of pipes, they should be 160px apart
    //each pipe is 54px wide and 400px high,
    //they are positioned to allow the ground to cut them off
    pipe1x=500;
    float tmpy=[self getRandomY:difficulty];
    pipe1yt=tmpy-(gapsize/2)-400;
    pipe1yb=tmpy+(gapsize/2);
    
    pipe2x=714;
    tmpy=[self getRandomY:difficulty];
    pipe2yt=tmpy-(gapsize/2)-400;
    pipe2yb=tmpy+(gapsize/2);
    
    pipe3x=928;
    tmpy=[self getRandomY:difficulty];
    pipe3yt=tmpy-(gapsize/2)-400;
    pipe3yb=tmpy+(gapsize/2);
    
    CGRect p1TFrame=CGRectMake(pipe1x, pipe1yt, 54, 400);
    CGRect p1BFrame=CGRectMake(pipe1x, pipe1yb, 54, 400);
    CGRect p2TFrame=CGRectMake(pipe2x, pipe2yt, 54, 400);
    CGRect p2BFrame=CGRectMake(pipe2x, pipe2yb, 54, 400);
    CGRect p3TFrame=CGRectMake(pipe3x, pipe3yt, 54, 400);
    CGRect p3BFrame=CGRectMake(pipe3x, pipe3yb, 54, 400);
    
    self.pipe1_top=[[UIImageView alloc] initWithFrame:p1TFrame];
    self.pipe1_bottom=[[UIImageView alloc] initWithFrame:p1BFrame];
    self.pipe2_top=[[UIImageView alloc] initWithFrame:p2TFrame];
    self.pipe2_bottom=[[UIImageView alloc] initWithFrame:p2BFrame];
    self.pipe3_top=[[UIImageView alloc] initWithFrame:p3TFrame];
    self.pipe3_bottom=[[UIImageView alloc] initWithFrame:p3BFrame];
    
    [self.view addSubview:self.pipe1_top];
    [self.view addSubview:self.pipe1_bottom];
    [self.view addSubview:self.pipe2_top];
    [self.view addSubview:self.pipe2_bottom];
    [self.view addSubview:self.pipe3_top];
    [self.view addSubview:self.pipe3_bottom];
    
    [self.pipe1_top setImage:[UIImage imageNamed:@"pipe_down.png"]];
    [self.pipe1_bottom setImage:[UIImage imageNamed:@"pipe_up.png"]];
    [self.pipe2_top setImage:[UIImage imageNamed:@"pipe_down.png"]];
    [self.pipe2_bottom setImage:[UIImage imageNamed:@"pipe_up.png"]];
    [self.pipe3_top setImage:[UIImage imageNamed:@"pipe_down.png"]];
    [self.pipe3_bottom setImage:[UIImage imageNamed:@"pipe_up.png"]];
    
    //place the ground
    CGRect g1Frame=CGRectMake(groundx,groundy,320,30);
    CGRect g2Frame=CGRectMake(ground2x,ground2y,320,30);
    self.ground1=[[UIImageView alloc] initWithFrame:g1Frame];
    self.ground2=[[UIImageView alloc] initWithFrame:g2Frame];
    [self.view addSubview:self.ground1];
    [self.view addSubview:self.ground2];
    [self.ground1 setImage:[UIImage imageNamed:@"ground.png"]];
    [self.ground2 setImage:[UIImage imageNamed:@"ground.png"]];
    
    CGRect blockFrame=CGRectMake(0,458,320,110);
    self.block=[[UIImageView alloc] initWithFrame:blockFrame];
    [self.view addSubview:self.block];
    [self.block setImage:[UIImage imageNamed:@"block.png"]];
    
    //place the bird
    CGRect birdFrame=CGRectMake(75, 269, 30, 22);
    self.bird=[[UIImageView alloc] initWithFrame:birdFrame];
    [self.view addSubview:self.bird];
    [self.bird setImage:[UIImage imageNamed:@"bird.png"]];
    
    //add the scoreboard
    CGRect scoresFrame=CGRectMake(20, 570, 280, 350);
    self.scoreboard=[[UIImageView alloc] initWithFrame:scoresFrame];
    [self.view addSubview:self.scoreboard];
    [self.scoreboard setImage:[UIImage imageNamed:@"scoreboard.png"]];
    [self.scoreboard setUserInteractionEnabled:YES];
    clickScoreBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartGame)];
    [self.scoreboard addGestureRecognizer:clickScoreBoard];
    
    CGRect scoreLabelFrame=CGRectMake(30,30,100,100);
    self.scoreLabel=[[UILabel alloc] initWithFrame:scoreLabelFrame];
    self.scoreLabel.text=@"0";
    self.scoreLabel.textColor=[UIColor whiteColor];
    [self.scoreboard addSubview:self.scoreLabel];
    
    
    
    
    NSLog(@"viewDidLoad");
}

//initialise ads view

-(void) adsInit{
    
    // Initialize the banner at the top of the screen.
    CGPoint origin = CGPointMake(0.0,0.0);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
    
    self.adBanner.adUnitID = @"ca-app-pub-8924442229168880/9605517056";
    self.adBanner.delegate = self;
    //self.adBanner.backgroundColor = [UIColor greenColor];
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
}


//handler for the frame based animations
- (void) doFrame
{
    //
    
    if(showScore)
    {
        if (startAds == TRUE)
        {
            NSLog(@"Show score.. should show ads here");
            startAds = FALSE;
            //show ads
            [self adsInit];
            
            
        }
        CGRect scoreFrame=self.scoreboard.frame;
        scoreFrame.origin.y-=30;
        self.scoreLabel.text=[NSString stringWithFormat:@"Score: %i",thisscore];
        
        if(scoreFrame.origin.y<scoreBoardYTarg)
        {
            scoreFrame.origin.y=scoreBoardYTarg;
        }
        self.scoreboard.frame=scoreFrame;
        
    }
    else if(started)
    {
        //apply gravity to the bird
        birdVerticalSpeed+=gravity;
        
        //increase the difficulty
        difficulty+=0.1;
        if(difficulty>100)
            difficulty=100;
        
        //get the frames for moving and checking collisions
        CGRect birdFrame=self.bird.frame;
        CGRect g1Frame=self.ground1.frame;
        CGRect g2Frame=self.ground2.frame;
        CGRect p1TFrame=self.pipe1_top.frame;
        CGRect p1BFrame=self.pipe1_bottom.frame;
        CGRect p2TFrame=self.pipe2_top.frame;
        CGRect p2BFrame=self.pipe2_bottom.frame;
        CGRect p3TFrame=self.pipe3_top.frame;
        CGRect p3BFrame=self.pipe3_bottom.frame;
        
        
        //move the bird
        birdFrame.origin.y+=birdVerticalSpeed;
        if(birdFrame.origin.y>birdBottom)
        {
            birdFrame.origin.y=birdBottom;
            crashed=YES;
            showScore=YES;
            NSLog(@"hit ground");
            birdVerticalSpeed=0;
        }
        self.bird.frame=birdFrame;
        
        
        
        //move the ground
        if(!crashed)
        {
            g1Frame.origin.x-=horizontalSpeed;
            g2Frame.origin.x-=horizontalSpeed;
            if(g1Frame.origin.x<-320)
                g1Frame.origin.x+=640;
            if(g2Frame.origin.x<-320)
                g2Frame.origin.x+=640;
            self.ground1.frame=g1Frame;
            self.ground2.frame=g2Frame;
        }
        //move pipe 1
        if(!crashed)
        {
            p1TFrame.origin.x-=horizontalSpeed;
            p1BFrame.origin.x-=horizontalSpeed;
            //check if we scored on this pipe
            if(self.bird.frame.origin.x>p1TFrame.origin.x && !passedPipe1)
            {
                passedPipe1=YES;
                thisscore+=1;
            }
            //reset pipe 1 when it goes off screen
            if(p1TFrame.origin.x<-54)
            {
                passedPipe1=NO;
                p1TFrame.origin.x+=642;
                p1BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p1TFrame.origin.y=tmpy-(gapsize/2)-400;
                p1BFrame.origin.y=tmpy+(gapsize/2);
            }
            self.pipe1_top.frame=p1TFrame;
            self.pipe1_bottom.frame=p1BFrame;
        }
        
        //move pipe 2
        if(!crashed)
        {
            p2TFrame.origin.x-=horizontalSpeed;
            p2BFrame.origin.x-=horizontalSpeed;
            //check if we scored on this pipe
            if(self.bird.frame.origin.x>p2TFrame.origin.x && !passedPipe2)
            {
                passedPipe2=YES;
                thisscore+=1;
            }
            //reset pipe 2 when it goes off screen
            if(p2TFrame.origin.x<-54)
            {
                passedPipe2=NO;
                p2TFrame.origin.x+=642;
                p2BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p2TFrame.origin.y=tmpy-(gapsize/2)-400;
                p2BFrame.origin.y=tmpy+(gapsize/2);
            }
            self.pipe2_top.frame=p2TFrame;
            self.pipe2_bottom.frame=p2BFrame;
        }
        
        //move pipe 3
        if(!crashed)
        {
            p3TFrame.origin.x-=horizontalSpeed;
            p3BFrame.origin.x-=horizontalSpeed;
            //check if we scored on this pipe
            if(self.bird.frame.origin.x>p3TFrame.origin.x && !passedPipe3)
            {
                passedPipe3=YES;
                thisscore+=1;
            }
            //reset pipe 3 when it goes off screen
            if(p3TFrame.origin.x<-54)
            {
                passedPipe3=NO;
                p3TFrame.origin.x+=642;
                p3BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p3TFrame.origin.y=tmpy-(gapsize/2)-400;
                p3BFrame.origin.y=tmpy+(gapsize/2);
            }
            self.pipe3_top.frame=p3TFrame;
            self.pipe3_bottom.frame=p3BFrame;
        }
        
        //check for collisions
        if (birdFrame.origin.x+30>p1TFrame.origin.x && birdFrame.origin.x<p1TFrame.origin.x+54 && birdFrame.origin.y+22>p1TFrame.origin.y && birdFrame.origin.y<p1TFrame.origin.y+400)
        {
            NSLog(@"hit pipe 1 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+30>p1BFrame.origin.x && birdFrame.origin.x<p1BFrame.origin.x+54 && birdFrame.origin.y+22>p1BFrame.origin.y && birdFrame.origin.y<p1BFrame.origin.y+400)
        {
            NSLog(@"hit pipe 1 bottom");
            crashed=YES;
        }
        if (birdFrame.origin.x+30>p2TFrame.origin.x && birdFrame.origin.x<p2TFrame.origin.x+54 && birdFrame.origin.y+22>p2TFrame.origin.y && birdFrame.origin.y<p2TFrame.origin.y+400)
        {
            NSLog(@"hit pipe 2 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+30>p2BFrame.origin.x && birdFrame.origin.x<p2BFrame.origin.x+54 && birdFrame.origin.y+22>p2BFrame.origin.y && birdFrame.origin.y<p2BFrame.origin.y+400)
        {
            NSLog(@"hit pipe 2 bottom");
            crashed=YES;
        }
        if (birdFrame.origin.x+30>p3TFrame.origin.x && birdFrame.origin.x<p3TFrame.origin.x+54 && birdFrame.origin.y+22>p3TFrame.origin.y && birdFrame.origin.y<p3TFrame.origin.y+400)
        {
            NSLog(@"hit pipe 3 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+30>p3BFrame.origin.x && birdFrame.origin.x<p3BFrame.origin.x+54 && birdFrame.origin.y+22>p3BFrame.origin.y && birdFrame.origin.y<p3BFrame.origin.y+400)
        {
            NSLog(@"hit pipe 3 bottom");
            crashed=YES;
        }
        
        
        //deal with the frame counter
        framecounter+=1;
        if (framecounter%frametrigger==0)
            framecounter=0;
    }
}

//get a new position for the pipes opening, is the midpoint y
//takes a difficulty rating up to 100 and makes the gaps more random based on this number
- (float)getRandomY: (float) myDifficulty
{
    //should return a number between 100 and 328
    float basenumber=myDifficulty*2+28;
    float result=drand48()*basenumber+(200-myDifficulty);
    return result;
}

//handler for the screen taps
- (void) screenTapReceiver:(UITapGestureRecognizer *)sender
{
    //CGPoint touchPoint = [sender locationInView:sender.view];
    
    if(started)
    {
        if(!crashed)
            birdVerticalSpeed=tapspeed;
    }
    else
    {
        started=YES;
        birdVerticalSpeed=tapspeed;
    }
}
- (void) restartGame
{
    //clear ads
    [self.adBanner removeFromSuperview];
    startAds=TRUE;
    
    //reset all variables and start again
    framecounter=0;
    frametrigger=200;
    bannerStartPoint=100;
    gravity=0.35;
    birdVerticalSpeed=0;
    tapspeed=-7;
    birdBottom=406;
    
    groundx=0;
    scoreBoardYTarg=100;
    ground2x=320;
    groundy=428;
    thisscore=0;
    ground2y=428;
    horizontalSpeed=3;
    difficulty=0;
    gapsize=120;
    
    //make starting positions of pipes, they should be 160px apart
    //each pipe is 54px wide and 400px high,
    //they are positioned to allow the ground to cut them off
    pipe1x=500;
    float tmpy=[self getRandomY:difficulty];
    pipe1yt=tmpy-(gapsize/2)-400;
    pipe1yb=tmpy+(gapsize/2);
    
    pipe2x=714;
    tmpy=[self getRandomY:difficulty];
    pipe2yt=tmpy-(gapsize/2)-400;
    pipe2yb=tmpy+(gapsize/2);
    
    pipe3x=928;
    tmpy=[self getRandomY:difficulty];
    pipe3yt=tmpy-(gapsize/2)-400;
    pipe3yb=tmpy+(gapsize/2);
    
    CGRect p1TFrame=self.pipe1_top.frame;
    p1TFrame.origin.x=pipe1x;
    p1TFrame.origin.y=pipe1yt;
    self.pipe1_top.frame=p1TFrame;
    
    CGRect p1BFrame=self.pipe1_bottom.frame;
    p1BFrame.origin.x=pipe1x;
    p1BFrame.origin.y=pipe1yb;
    self.pipe1_bottom.frame=p1BFrame;
    
    CGRect p2TFrame=self.pipe2_top.frame;//  CGRectMake(pipe2x, pipe2yt, 54, 400);
    p2TFrame.origin.x=pipe2x;
    p2TFrame.origin.y=pipe2yt;
    self.pipe2_top.frame=p2TFrame;
    
    CGRect p2BFrame=self.pipe2_bottom.frame;//  CGRectMake(pipe2x, pipe2yb, 54, 400);
    p2BFrame.origin.x=pipe2x;
    p2BFrame.origin.y=pipe2yb;
    self.pipe2_bottom.frame=p2BFrame;
    
    CGRect p3TFrame=self.pipe3_top.frame;//  CGRectMake(pipe3x, pipe3yt, 54, 400);
    p3TFrame.origin.x=pipe3x;
    p3TFrame.origin.y=pipe3yt;
    self.pipe3_top.frame=p3TFrame;
    
    CGRect p3BFrame=self.pipe3_bottom.frame;//  CGRectMake(pipe3x, pipe3yb, 54, 400);
    p3BFrame.origin.x=pipe3x;
    p3BFrame.origin.y=pipe3yb;
    self.pipe3_bottom.frame=p3BFrame;
    
    //place the ground
    CGRect g1Frame=self.ground1.frame;
    g1Frame.origin.x=groundx;
    CGRect g2Frame=self.ground2.frame;
    g2Frame.origin.x=ground2x;
    self.ground1.frame=g1Frame;
    self.ground2.frame=g2Frame;
    
    //place the bird
    CGRect birdFrame=self.bird.frame;
    birdFrame.origin.y=269;
    self.bird.frame=birdFrame;
    
    //add the scoreboard
    CGRect scoresFrame=self.scoreboard.frame;
    scoresFrame.origin.y=570;
    self.scoreboard.frame=scoresFrame;
    passedPipe1=NO;
    passedPipe2=NO;
    passedPipe3=NO;
    started=NO;
    showScore=NO;
    crashed=NO;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // you want to receive test ads.
    //request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


@end
