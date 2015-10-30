//
//  ABOnboardingContentViewController.m
//  Pods
//
//  Created by Alejandro Benito on 06/10/2015.
//
//

#import "ABOnboardingContentViewController.h"

@interface ABOnboardingContentViewController ()

@end

@implementation ABOnboardingContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation ABOnboardingContentViewController (ParentController)

- (ABOnboardingViewController *)onBoardingViewController
{
    UIViewController *viewController = self;
    while (viewController.parentViewController) {
        if ([viewController.parentViewController isKindOfClass:[ABOnboardingViewController class]]) {
            return (ABOnboardingViewController *)viewController.parentViewController;
        } else {
            viewController = viewController.parentViewController;
        }
    }
    NSAssert(viewController, @"Couldn't find parent onboarding view controller");
    return nil;
}

@end
