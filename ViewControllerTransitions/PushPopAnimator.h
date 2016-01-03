//
//  PushPopAnimator.h
//  ViewControllerTransitions
//
//  Created by Ash Robinson on 03/01/2016.
//  Copyright © 2016 Example. All rights reserved.
//

@import UIKit;

@interface PushPopAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic, getter=isPresenting) BOOL presenting;

@end
