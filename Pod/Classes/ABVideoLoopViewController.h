//
//  ABVideoLoopViewController.h
//  Pods
//
//  Created by Alejandro Benito Santos on 21/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "ABOnboardingContentViewController.h"

@interface ABVideoLoopViewController : ABOnboardingContentViewController

@property (weak, nonatomic)     UIView *videoPlayerView;
@property (strong, nonatomic)   IBInspectable NSString *videoFileName;

@end
