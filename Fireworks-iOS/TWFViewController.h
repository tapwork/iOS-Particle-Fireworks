//
//  TWFViewController.h
//  Fireworks-iOS
//
//  Created by Victoria Lechnowitsch on 11.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>


@interface TWFViewController : UIViewController
{
    UIView *backView;
	
	CAEmitterLayer *mortor;
}

- (void)addParticlesWithPoint:(CGPoint)point;

@end
