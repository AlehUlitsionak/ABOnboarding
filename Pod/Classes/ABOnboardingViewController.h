//
//  ABWalkthroughViewController.h
//  ABWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const ABMotionFrameOffset;

@protocol ABWalkthroughViewControllerDelegate;

@interface ABOnboardingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic, readonly) NSArray *childrenStoryboardIds;
//@property (strong, nonatomic) UIScrollView *scrollView;
//@property (readonly, nonatomic) TAPageControl *pageControl;
//@property (assign, nonatomic) id<ABWalkthroughViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL rounderCorners;
@property (assign, nonatomic) BOOL showInitialAnimation;

+ (instancetype)onboardingViewControllerWithChildrenStoryboardIds:(NSArray *)childrenStoryboardIds
                                                    forStoryboard:(UIStoryboard *)storyboard;
//- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance;
//- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance;
//- (void)showTooltipAtPageIndex:(NSUInteger)index withText:(NSString *)text andDuration:(NSTimeInterval)duration;
//- (void)hideTooltipAtPageIndex:(NSUInteger)index;

- (void)requestPushNotifications;
- (void)finishOnboarding;

#pragma mark - Setup

//- (void)finishSetup;

@end

@protocol ABWalkthroughViewControllerDelegate <NSObject>

- (void)walkthroughViewController:(ABOnboardingViewController *)walkthroughViewController
            didPressButtonWithTag:(NSInteger)tag;
- (void)walkthroughViewController:(ABOnboardingViewController *)walkthroughViewController
          didScrollToSlideWithTag:(NSInteger)tag;
- (void)walkthroughViewControllerDidAppear:(ABOnboardingViewController *)walkthroughViewController;
- (void)walkthroughViewControllerDidFinishLoadingVideos:(ABOnboardingViewController *)walkthroughViewController;
@end
