//
//  TWFViewController.m
//  Fireworks-iOS
//
//  Created by Victoria Lechnowitsch on 11.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TWFViewController.h"

@implementation TWFViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = self.view.backgroundColor;
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(tapGesture:)]; 
    [self.view addGestureRecognizer:tapGesture];
    
    //Create the root layer
	CALayer *rootLayer = [CALayer layer];
    rootLayer.bounds = self.view.bounds; //CGRectMake(0, 0, 640, 480);
    rootLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    mortor = [CAEmitterLayer layer];
    
	//Set the view's layer to the base layer
    [rootLayer addSublayer:mortor];
    [backView.layer addSublayer:rootLayer];

}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    [self addParticlesWithPoint:[gesture locationInView:backView]];
}

- (void)addParticlesWithPoint:(CGPoint)point
{
   
    CGPoint originalPoint = CGPointMake(CGRectGetMaxX(backView.bounds),
                                        CGRectGetMaxY(backView.bounds));
    
    CGPoint newOriginPoint = CGPointMake(originalPoint.x - originalPoint.x/2,
                                         originalPoint.y - originalPoint.y/2);
    
    CGPoint position = CGPointMake(newOriginPoint.x + point.x,
                                   newOriginPoint.y + point.y);
    
    UIImage *image = [UIImage imageNamed:@"tspark.png"];
    
	
	mortor.emitterPosition = position;
	mortor.renderMode = kCAEmitterLayerBackToFront;
	
	//Invisible particle representing the rocket before the explosion
	CAEmitterCell *rocket = [CAEmitterCell emitterCell];
	rocket.emissionLongitude = M_PI / 2;
	rocket.emissionLatitude = 0;
	rocket.lifetime = 1.6;
	rocket.birthRate = 1;
	rocket.velocity = 40;
	rocket.velocityRange = 100;
	rocket.yAcceleration = -250;
	rocket.emissionRange = M_PI / 4;
	rocket.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
	rocket.redRange = 0.5;
	rocket.greenRange = 0.5;
	rocket.blueRange = 0.5;
	
	//Name the cell so that it can be animated later using keypath
	[rocket setName:@"rocket"];
	
	//Flare particles emitted from the rocket as it flys
	CAEmitterCell *flare = [CAEmitterCell emitterCell];
	flare.contents = (id)image.CGImage;
	flare.emissionLongitude = (4 * M_PI) / 2;
	flare.scale = 0.4;
	flare.velocity = 100;
	flare.birthRate = 45;
	flare.lifetime = 1.5;
	flare.yAcceleration = -350;
	flare.emissionRange = M_PI / 7;
	flare.alphaSpeed = -0.7;
	flare.scaleSpeed = -0.1;
	flare.scaleRange = 0.1;
	flare.beginTime = 0.01;
	flare.duration = 0.7;
	
	//The particles that make up the explosion
	CAEmitterCell *firework = [CAEmitterCell emitterCell];
	firework.contents = (id)image.CGImage;
	firework.birthRate = 9999;
	firework.scale = 0.6;
	firework.velocity = 130;
	firework.lifetime = 2;
	firework.alphaSpeed = -0.2;
	firework.yAcceleration = -80;
	firework.beginTime = 1.5;
	firework.duration = 0.1;
	firework.emissionRange = 2 * M_PI;
	firework.scaleSpeed = -0.1;
	firework.spin = 2;
	
	//Name the cell so that it can be animated later using keypath
	[firework setName:@"firework"];
	
	//preSpark is an invisible particle used to later emit the spark
	CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
	preSpark.birthRate = 80;
	preSpark.velocity = firework.velocity * 0.70;
	preSpark.lifetime = 1.7;
	preSpark.yAcceleration = firework.yAcceleration * 0.85;
	preSpark.beginTime = firework.beginTime - 0.2;
	preSpark.emissionRange = firework.emissionRange;
	preSpark.greenSpeed = 100;
	preSpark.blueSpeed = 100;
	preSpark.redSpeed = 100;
	
	//Name the cell so that it can be animated later using keypath
	[preSpark setName:@"preSpark"];
	
	//The 'sparkle' at the end of a firework
	CAEmitterCell *spark = [CAEmitterCell emitterCell];
	spark.contents = (id)image.CGImage;
	spark.lifetime = 0.05;
	spark.yAcceleration = -250;
	spark.beginTime = 0.8;
	spark.scale = 0.4;
	spark.birthRate = 10;
	
	preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
	rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
	mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];
	
	
    //Force the view to update
	[backView setNeedsDisplay];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
