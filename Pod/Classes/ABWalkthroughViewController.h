//
//  ABWalkthroughViewController.h
//  ABWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TAPageControl.h>
#import "ABInterface.h"

extern CGFloat const ABMotionFrameOffset;

@protocol ABWalkthroughViewControllerDelegate;

@interface ABWalkthroughViewController : UIViewController <UIScrollViewDelegate, ABInterfaceDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (readonly, nonatomic) TAPageControl *pageControl;
@property (assign, nonatomic) id<ABWalkthroughViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL rounderCorners;
@property (assign, nonatomic) BOOL showInitialAnimation;

- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance;
- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance;
- (void)showTooltipAtPageIndex:(NSUInteger)index withText:(NSString *)text andDuration:(NSTimeInterval)duration;
- (void)hideTooltipAtPageIndex:(NSUInteger)index;

#pragma mark - Setup

- (void)finishSetup;

@end

@protocol ABWalkthroughViewControllerDelegate <NSObject>

- (void)walkthroughViewController:(ABWalkthroughViewController *)walkthroughViewController didPressButtonWithTag:(NSInteger)tag;
- (void)walkthroughViewController:(ABWalkthroughViewController *)walkthroughViewController didScrollToSlideWithTag:(NSInteger)tag;
- (void)walkthroughViewControllerDidAppear:(ABWalkthroughViewController *)walkthroughViewController;
- (void)walkthroughViewControllerDidFinishLoadingVideos:(ABWalkthroughViewController *)walkthroughViewController;
@end
