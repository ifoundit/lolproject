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
    
    //preload the fish images
    fishImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"fish_l2-60.png"],[UIImage imageNamed:@"fish_l1-60.png"],[UIImage imageNamed:@"fish_n-60.png"],[UIImage imageNamed:@"fish_r1-60.png"],[UIImage imageNamed:@"fish_r2-60.png"],[UIImage imageNamed:@"fish_l2-30.png"],[UIImage imageNamed:@"fish_l1-30.png"],[UIImage imageNamed:@"fish_n-30.png"],[UIImage imageNamed:@"fish_r1-30.png"],[UIImage imageNamed:@"fish_r2-30.png"],[UIImage imageNamed:@"fish_l2-0.png"],[UIImage imageNamed:@"fish_l1-0.png"],[UIImage imageNamed:@"fish_n-0.png"],[UIImage imageNamed:@"fish_r1-0.png"],[UIImage imageNamed:@"fish_r2-0.png"],[UIImage imageNamed:@"fish_l2+30.png"],[UIImage imageNamed:@"fish_l1+30.png"],[UIImage imageNamed:@"fish_n+30.png"],[UIImage imageNamed:@"fish_r1+30.png"],[UIImage imageNamed:@"fish_r2+30.png"],[UIImage imageNamed:@"fish_l2+60.png"],[UIImage imageNamed:@"fish_l1+60.png"],[UIImage imageNamed:@"fish_n+60.png"],[UIImage imageNamed:@"fish_r1+60.png"],[UIImage imageNamed:@"fish_r2+60.png"],[UIImage imageNamed:@"fish_l2+90.png"],[UIImage imageNamed:@"fish_l1+90.png"],[UIImage imageNamed:@"fish_n+90.png"],[UIImage imageNamed:@"fish_r1+90.png"],[UIImage imageNamed:@"fish_r2+90.png"], nil];
    
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
    fishVerticalSpeed=0;
    tapspeed=-7;
    fishBottom=406;
    fishFrame=0;
    fishFrameDelay=4;
    fishFrameForwards=YES;
    
    started=NO;
    showScore=NO;
    crashed=NO;
    passedPipe1=NO;
    passedPipe2=NO;
    passedPipe3=NO;
    groundx=0;
    scoreBoardYTarg=100;
    ground2x=320;
    groundy=398;
    ground2y=398;
    thisscore=0;
    horizontalSpeed=2;
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
    
    CGRect p1TFrame=CGRectMake(pipe1x, pipe1yt, 60, 400);
    CGRect p1BFrame=CGRectMake(pipe1x, pipe1yb, 60, 400);
    CGRect p2TFrame=CGRectMake(pipe2x, pipe2yt, 60, 400);
    CGRect p2BFrame=CGRectMake(pipe2x, pipe2yb, 60, 400);
    CGRect p3TFrame=CGRectMake(pipe3x, pipe3yt, 60, 400);
    CGRect p3BFrame=CGRectMake(pipe3x, pipe3yb, 60, 400);
    
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
    
    [self.pipe1_top setImage:[UIImage imageNamed:@"seaweed_top.png"]];
    [self.pipe1_bottom setImage:[UIImage imageNamed:@"seaweed_bottom.png"]];
    [self.pipe2_top setImage:[UIImage imageNamed:@"seaweed_top.png"]];
    [self.pipe2_bottom setImage:[UIImage imageNamed:@"seaweed_bottom.png"]];
    [self.pipe3_top setImage:[UIImage imageNamed:@"seaweed_top.png"]];
    [self.pipe3_bottom setImage:[UIImage imageNamed:@"seaweed_bottom.png"]];
    
    //place the ground
    CGRect g1Frame=CGRectMake(groundx,groundy,320,73);
    CGRect g2Frame=CGRectMake(ground2x,ground2y,320,73);
    self.ground1=[[UIImageView alloc] initWithFrame:g1Frame];
    self.ground2=[[UIImageView alloc] initWithFrame:g2Frame];
    [self.view addSubview:self.ground1];
    [self.view addSubview:self.ground2];
    [self.ground1 setImage:[UIImage imageNamed:@"sand.png"]];
    [self.ground2 setImage:[UIImage imageNamed:@"sand.png"]];
    
    CGRect blockFrame=CGRectMake(0,471,320,110);
    self.block=[[UIImageView alloc] initWithFrame:blockFrame];
    [self.view addSubview:self.block];
    [self.block setImage:[UIImage imageNamed:@"block.png"]];
    
    //place the fish
    CGRect birdFrame=CGRectMake(75, 269, 30, 25);
    self.fish=[[UIImageView alloc] initWithFrame:birdFrame];
    [self.view addSubview:self.fish];
    [self setFishFrame];
    
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
        fishVerticalSpeed+=gravity;
        
        //animate the fish
        [self setFishFrame];
        
        
        //increase the difficulty
        difficulty+=0.1;
        if(difficulty>100)
            difficulty=100;
        
        //get the frames for moving and checking collisions
        CGRect birdFrame=self.fish.frame;
        CGRect g1Frame=self.ground1.frame;
        CGRect g2Frame=self.ground2.frame;
        CGRect p1TFrame=self.pipe1_top.frame;
        CGRect p1BFrame=self.pipe1_bottom.frame;
        CGRect p2TFrame=self.pipe2_top.frame;
        CGRect p2BFrame=self.pipe2_bottom.frame;
        CGRect p3TFrame=self.pipe3_top.frame;
        CGRect p3BFrame=self.pipe3_bottom.frame;
        
        
        //move the bird
        birdFrame.origin.y+=fishVerticalSpeed;
        if(birdFrame.origin.y>fishBottom)
        {
            birdFrame.origin.y=fishBottom;
            crashed=YES;
            showScore=YES;
            NSLog(@"hit ground");
            fishVerticalSpeed=0;
        }
        self.fish.frame=birdFrame;
        
        //get current height and width of fish image
        float currentFishWidth=birdFrame.size.width;
        float currentFishHeight=birdFrame.size.width;
        
        //get current height and width of seaweed image
        float currentSeaweedWidth=p1TFrame.size.width;
        float currentSeaweedHeight=p1TFrame.size.height;
        
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
            if(self.fish.frame.origin.x>p1TFrame.origin.x && !passedPipe1)
            {
                passedPipe1=YES;
                thisscore+=1;
            }
            //reset pipe 1 when it goes off screen
            if(p1TFrame.origin.x<-currentSeaweedWidth)
            {
                passedPipe1=NO;
                p1TFrame.origin.x+=642;
                p1BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p1TFrame.origin.y=tmpy-(gapsize/2)-currentSeaweedHeight;
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
            if(self.fish.frame.origin.x>p2TFrame.origin.x && !passedPipe2)
            {
                passedPipe2=YES;
                thisscore+=1;
            }
            //reset pipe 2 when it goes off screen
            if(p2TFrame.origin.x<-currentSeaweedWidth)
            {
                passedPipe2=NO;
                p2TFrame.origin.x+=642;
                p2BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p2TFrame.origin.y=tmpy-(gapsize/2)-currentSeaweedHeight;
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
            if(self.fish.frame.origin.x>p3TFrame.origin.x && !passedPipe3)
            {
                passedPipe3=YES;
                thisscore+=1;
            }
            //reset pipe 3 when it goes off screen
            if(p3TFrame.origin.x<-currentSeaweedWidth)
            {
                passedPipe3=NO;
                p3TFrame.origin.x+=642;
                p3BFrame.origin.x+=642;
                float tmpy=[self getRandomY:difficulty];
                p3TFrame.origin.y=tmpy-(gapsize/2)-currentSeaweedHeight;
                p3BFrame.origin.y=tmpy+(gapsize/2);
            }
            self.pipe3_top.frame=p3TFrame;
            self.pipe3_bottom.frame=p3BFrame;
        }
        
        
        
        //check for collisions
        if (birdFrame.origin.x+currentFishWidth>p1TFrame.origin.x && birdFrame.origin.x<p1TFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p1TFrame.origin.y && birdFrame.origin.y<p1TFrame.origin.y+currentSeaweedHeight)
        {
            NSLog(@"hit pipe 1 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+currentFishWidth>p1BFrame.origin.x && birdFrame.origin.x<p1BFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p1BFrame.origin.y && birdFrame.origin.y<p1BFrame.origin.y+currentSeaweedHeight)
        {
            NSLog(@"hit pipe 1 bottom");
            crashed=YES;
        }
        if (birdFrame.origin.x+currentFishWidth>p2TFrame.origin.x && birdFrame.origin.x<p2TFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p2TFrame.origin.y && birdFrame.origin.y<p2TFrame.origin.y+currentSeaweedHeight)
        {
            NSLog(@"hit pipe 2 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+currentFishWidth>p2BFrame.origin.x && birdFrame.origin.x<p2BFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p2BFrame.origin.y && birdFrame.origin.y<p2BFrame.origin.y+currentSeaweedHeight)
        {
            NSLog(@"hit pipe 2 bottom");
            crashed=YES;
        }
        if (birdFrame.origin.x+currentFishWidth>p3TFrame.origin.x && birdFrame.origin.x<p3TFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p3TFrame.origin.y && birdFrame.origin.y<p3TFrame.origin.y+currentSeaweedHeight)
        {
            NSLog(@"hit pipe 3 top");
            crashed=YES;
        }
        if (birdFrame.origin.x+currentFishWidth>p3BFrame.origin.x && birdFrame.origin.x<p3BFrame.origin.x+currentSeaweedWidth && birdFrame.origin.y+currentFishHeight>p3BFrame.origin.y && birdFrame.origin.y<p3BFrame.origin.y+currentSeaweedHeight)
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
            fishVerticalSpeed=tapspeed;
    }
    else
    {
        started=YES;
        fishVerticalSpeed=tapspeed;
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
    fishVerticalSpeed=0;
    tapspeed=-7;
    fishBottom=406;
    
    groundx=0;
    scoreBoardYTarg=100;
    ground2x=320;
    groundy=398;
    thisscore=0;
    ground2y=398;
    horizontalSpeed=2;
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
    CGRect birdFrame=self.fish.frame;
    birdFrame.origin.y=269;
    self.fish.frame=birdFrame;
    
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

- (void) setFishFrame
{
    fishFrameDelay+=1;
    bool changed=NO;
    if(fishFrameDelay==5)
    {
        changed=YES;
        if(fishFrameForwards)
        {
            fishFrame+=1;
            if(fishFrame==5)
            {
                fishFrameForwards=NO;
                fishFrame=3;
            }
        }
        else
        {
            fishFrame-=1;
            if(fishFrame==-1)
            {
                fishFrameForwards=YES;
                fishFrame=1;
            }
        }
        fishFrameDelay=0;
    }
    if(changed)
    {
        //work out angle offset for array, -60 is between 0-4, -30 is between 5-9, neutral is between 10-14
        //+30 is between 15-19, +60 is between 20-24 and +90 is between 25-29
        
        NSLog(@"vertical speed: %f", fishVerticalSpeed);
        
        //verticalSpeedIndex is a number between 0 and 5, depending on what angle we should be pointing at
        int verticalSpeedIndex;
        
        if(fishVerticalSpeed<=-6)
            verticalSpeedIndex=0;
        if(fishVerticalSpeed>-6 && fishVerticalSpeed<=-1)
            verticalSpeedIndex=1;
        if(fishVerticalSpeed>-1 && fishVerticalSpeed<=2)
            verticalSpeedIndex=2;
        if(fishVerticalSpeed>2 && fishVerticalSpeed<=4)
            verticalSpeedIndex=3;
        if(fishVerticalSpeed>4 && fishVerticalSpeed<=6)
            verticalSpeedIndex=4;
        if(crashed || (fishVerticalSpeed>6))
            verticalSpeedIndex=5;
        
        //set the imageviews image and the frame to use to display it
        int angleIndexOffset=verticalSpeedIndex*5+fishFrame;
        CGRect oldFrame=self.fish.frame;
        UIImage *tmp=[fishImages objectAtIndex:angleIndexOffset];
        oldFrame.size.width=tmp.size.width;
        oldFrame.size.height=tmp.size.height;
        [self.fish setFrame:oldFrame];
        [self.fish setImage:[fishImages objectAtIndex:angleIndexOffset]];
        
        //reset the frame delay
        fishFrameDelay=0;
    }
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
