//
//  ABOnboardingContentViewController.h
//  Pods
//
//  Created by Alejandro Benito on 06/10/2015.
//
//

#import "ABOnboardingViewController.h"
#import <UIKit/UIKit.h>

@interface ABOnboardingContentViewController : UIViewController

@end

@interface ABOnboardingContentViewController (ParentController)

- (ABOnboardingViewController *)onBoardingViewController;

@end
