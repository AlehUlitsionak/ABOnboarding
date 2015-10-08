//
//  ABWalkthroughViewController.m
//  ABWalkthrough
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "ABOnboardingViewController.h"
#import "ABInterface.h"
#import "ABVideoLoopViewController.h"
#import <AMPopTip.h>
#import <QuartzCore/QuartzCore.h>
#import <AVAnimator/AVAnimatorMedia.h>


typedef NS_ENUM(NSInteger, ABWalkthroughSlideType) {
    ABWalkthroughSlideTypePicture,
    ABWalkthroughSlideTypeVideo
};

typedef NS_ENUM(NSInteger, ABWalkthroughScrollDirection) {
    ABWalkthroughScrollDirectionLeft,
    ABWalkthroughScrollDirectionRight
};


static CGFloat const ABPercentageMultiplier = 0.4;
CGFloat const ABMotionFrameOffset    = 15.0;

static NSString *const kABWalkthroughTextDistanceKey        = @"ABWalkthroughTextDistanceKey";
static NSString *const kABWalkthroughDescriptionTextKey     = @"ABWalkthroughDescriptionTextKey";

@interface ABOnboardingViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *childrenStoryboardIds;
@property (strong, nonatomic) NSMutableArray *contentViewControllers;

@property (strong, nonatomic) NSMutableArray *descriptions;
@property (strong, nonatomic) NSMutableArray *slideTypes;
@property (strong, nonatomic) NSMutableArray *videoFileNames;
@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) TAPageControl *pageControl;

@property (assign, nonatomic) NSInteger otherPageNumber;
@property (assign, nonatomic) CGFloat lastContentOffset;

@end

@implementation ABOnboardingViewController

CGFloat getFrameHeight(ABOnboardingViewController *object)
{
    static CGFloat height;
    if (!height) {
        height = CGRectGetHeight(object.view.frame);
    }
    return height;
}

CGFloat getFrameWidth(ABOnboardingViewController *object)
{
    static CGFloat width;
    if (!width) {
        width = CGRectGetWidth(object.view.frame);
    }
    return width;
}

+ (instancetype)onboardingViewControllerWithChildrenStoryboardIds:(NSArray *)childrenStoryboardIds
                                                    forStoryboard:(UIStoryboard *)storyboard
{
    NSParameterAssert(childrenStoryboardIds);
    NSParameterAssert(storyboard);
    NSAssert([childrenStoryboardIds count] > 0, @"Must provide at least one storyboard ID");
    
    ABOnboardingViewController *onboardingVC = [storyboard instantiateInitialViewController];
    NSAssert([onboardingVC isKindOfClass:[ABOnboardingViewController class]],
             @"Initial view controller must be of class %@",
             NSStringFromClass([ABOnboardingViewController class]));
    onboardingVC.childrenStoryboardIds = childrenStoryboardIds;
    
    [onboardingVC _setupPageViewController];
    
    return onboardingVC;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _viewControllers = [NSMutableArray new];
        _descriptions = [NSMutableArray new];
        _slideTypes = [NSMutableArray new];
        _videoFileNames = [NSMutableArray new];
        _images = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor redColor]];
//    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces = NO;
//    self.scrollView.delegate = self;
//    
//    [self.view addSubview:self.scrollView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
    [gradientLayer setEndPoint:CGPointMake(0.5, 1.0)];
    gradientLayer.colors = @[(id)[UIColor colorWithRed:247.0f / 255.0f green:152.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f].CGColor,
                             (id)[UIColor colorWithRed:242.0f / 255.0f green:128.0f / 255.0f blue:105.0f / 255.0f alpha:1.0f].CGColor];
    [gradientLayer setFrame:self.view.bounds];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (self.navigationController) {
//        [self.viewControllers makeObjectsPerformSelector:@selector(viewWillAppear:)];
//    }
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (self.showInitialAnimation) {
//        [self performInitialAnimation];
//    }
//    
//    if (self.navigationController) {
//        [self.viewControllers makeObjectsPerformSelector:@selector(viewDidAppear:)];
//    }
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewControllerDidAppear:)]) {
//        [self.delegate walkthroughViewControllerDidAppear:self];
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)requestPushNotifications
{
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)finishOnboarding
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup page controller
- (void)_setupPageViewController
{
    NSAssert(self.childrenStoryboardIds, @"Children Ids must be set before attempting to configure the \
             internal page view controller");
    UIScrollView *scrollView;

    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
            [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
//            [(UIScrollView *)view setDelegate:self];
        }
    }
    
    UIView *pageView = self.pageViewController.view;
    
    NSDictionary *scrollBinding  = NSDictionaryOfVariableBindings(scrollView, pageView);
    
    
    [self.pageViewController.view setBackgroundColor:[UIColor clearColor]];
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.pageViewController.view addConstraints:[NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                  options:0
                                                  metrics:nil
                                                  views:scrollBinding]];
    [self.pageViewController.view addConstraints:[NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                  options:0
                                                  metrics:nil
                                                  views:scrollBinding]];
    
    
    [self.view addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V:|[pageView]|"
                              options:0
                              metrics:nil
                              views:scrollBinding]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[pageView]|"
                               options:0
                               metrics:nil
                               views:scrollBinding]];
    
    
//    LITKeyboardViewController *litKeyboardViewController = [self instantiateKeyboardControllerForIndex:0];
//    [self.pageViewController setViewControllers:@[litKeyboardViewController]
//                                      direction:UIPageViewControllerNavigationDirectionForward
//                                       animated:NO
//                                     completion:nil];
}
#pragma mark - Page Addition
//
//- (void)addPageWithImage:(UIImage *)image andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance;
//{
//    NSParameterAssert(image);
//    
//    [self.images addObject:image];
//    [self.slideTypes addObject:@(ABWalkthroughSlideTypePicture)];
//
//    if (description) {
//        [self.descriptions addObject:@{kABWalkthroughDescriptionTextKey :description,
//                                       kABWalkthroughTextDistanceKey : @(textDistance)}];
//    }
//}
//
//- (void)addPageWithVideoFileName:(NSString *)videoFileName andDescription:(NSString *)description withDistanceToTopLayoutGuide:(CGFloat)textDistance
//{
//    NSParameterAssert(videoFileName);
//    [self.videoFileNames addObject:videoFileName];
//    [self.slideTypes addObject:@(ABWalkthroughSlideTypeVideo)];
//    
//    if (description) {
//        [self.descriptions addObject:@{kABWalkthroughDescriptionTextKey :description,
//                                       kABWalkthroughTextDistanceKey : @(textDistance)}];
//    }
//}

//#pragma Tooltip
//
//- (void)showTooltipAtPageIndex:(NSUInteger)index withText:(NSString *)text andDuration:(NSTimeInterval)duration
//{
//    AMPopTip *popTip = [AMPopTip popTip];
//    popTip.shouldDismissOnTapOutside = YES;
//    [popTip showText:text direction:AMPopTipDirectionUp maxWidth:200.0f inView:[self.viewControllers[index] view] fromFrame:self.pageControl.frame duration:duration];
//}
//
//- (void)hideTooltipAtPageIndex:(NSUInteger)index
//{
//    for (UIView *view in [[self.viewControllers[index] view] subviews]) {
//        if ([view isKindOfClass:[AMPopTip class]]) {
//            [((AMPopTip *)view) hide];
//            break;
//        }
//    }
//}


//#pragma mark - Setup Methods
//
//- (void)finishSetup
//{
//    CGFloat width = getFrameWidth(self);
//    CGFloat height = getFrameHeight(self);
//    
//    NSInteger slideIndex, videoIndex, imageIndex;
//    slideIndex = videoIndex = imageIndex = 0;
//    
//    for (NSNumber *collectionType in self.slideTypes) {
//        ABWalkthroughSlideType slideType = collectionType.integerValue;
//        UIViewController *viewController;
//        NSDictionary *descriptionObject = self.descriptions[slideIndex];
//        NSString *text = descriptionObject[kABWalkthroughDescriptionTextKey];
//        CGFloat textDistance = [descriptionObject[kABWalkthroughTextDistanceKey] floatValue];
//        if (slideType == ABWalkthroughSlideTypeVideo) {
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadedNotification:) name:AVAnimatorPreparedToAnimateNotification object:nil];
//            NSString *videoFileName = self.videoFileNames[videoIndex++];
//            ABVideoLoopViewController *playerViewController = [[ABVideoLoopViewController alloc] initWithText:text andDistanceToTopLayoutGuide:textDistance];
//            playerViewController.resFileName = videoFileName;
//            viewController = playerViewController;
//            [self.viewControllers addObject:playerViewController];
//        } else if (slideType == ABWalkthroughSlideTypePicture) {
//            UIImage *image = self.images[imageIndex++];
//            ABInterface *imageController = [[ABInterface alloc] initWithNibName:@"ABSimpleImage" tag:slideIndex image:image text:text andDistanceToTopLayoutGuide:textDistance];
//            [imageController setDelegate:self];
//            viewController = imageController;
//            [self.viewControllers addObject:imageController];
//        }
//        
//        CGFloat diff = 0.0f;
//        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(width * slideIndex, 0.0f, width, height)];
//        UIScrollView *internalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(diff, 0.0f, width - (diff * 2.0), height)];
//        internalScrollView.scrollEnabled = NO;
//        
//        [viewController.view setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(internalScrollView.frame) + ABMotionFrameOffset, CGRectGetHeight(internalScrollView.frame))];
//        
//        internalScrollView.tag = (slideIndex + 1) * 10;
//        viewController.view.tag = (slideIndex + 1) * 1000;
//        
//        [internalScrollView addSubview:viewController.view];
//        [subView addSubview:internalScrollView];
//        
//        [self.scrollView addSubview:subView];
//        
//        slideIndex++;
//    }
//
//    
//    self.scrollView.contentSize = CGSizeMake(width * [self.viewControllers count], height);
//    
//    
//    // Adding Page Control
//    [self.view addSubview:self.pageControl];
//}

#pragma mark - UIPageControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
//    if (completed) {
//        UIViewController *controller = [pageViewController.viewControllers lastObject];
//        self.currentPage = [self.keyboardViewControllers indexOfObject:controller];
//    }
}

- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
//    if (((LITKeyboardViewController *)viewController).index == 0) {
//        return nil;
//    } else
//        return [self
//                instantiateKeyboardControllerForIndex:((LITKeyboardViewController *)viewController).index -1];
    NSAssert(viewController.restorationIdentifier, @"You must set the restoration identifier for\
             all children view controllers in Interface Builder. Please check the option 'Use Storyboard ID'");
    NSUInteger index = [self.childrenStoryboardIds indexOfObject:viewController.restorationIdentifier];
    NSAssert(index != NSNotFound, @"The restoration identifier for this view controller couldn't be found in\
             the initial set of identifiers provided");
    if (index == 0) {
        return nil;
    } else {
        return [self.storyboard instantiateViewControllerWithIdentifier:self.childrenStoryboardIds[index - 1]];
    }

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
//    if (((LITKeyboardViewController *)viewController).index == [self.keyboards count] - 1) {
//        return nil;
//    } else
//        return [self
//                instantiateKeyboardControllerForIndex:((LITKeyboardViewController *)viewController).index +1];
    NSAssert(viewController.restorationIdentifier, @"You must set the restoration identifier for\
             all children view controllers in Interface Builder. Please check the option 'Use Storyboard ID'");
    NSUInteger index = [self.childrenStoryboardIds indexOfObject:viewController.restorationIdentifier];
    NSAssert(index != NSNotFound, @"The restoration identifier for this view controller couldn't be found in\
             the initial set of identifiers provided");
    if (index == [self.childrenStoryboardIds count] - 1) {
        return nil;
    } else {
        return [self.storyboard instantiateViewControllerWithIdentifier:self.childrenStoryboardIds[index + 1]];
    }
}

#pragma pageControl
//- (TAPageControl *)pageControl
//{
//    if (!_pageControl) {
//        CGFloat pageControlY = CGRectGetHeight(self.view.frame) * 0.90;
//        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, pageControlY, CGRectGetWidth(self.view.frame), 40)];
//        [_pageControl setDotViewClass:[CustomDotView class]];
//        [_pageControl setNumberOfPages:[self.viewControllers count]];
////        [_pageControl setProgressive:YES];
//        [_pageControl setDotSize:CGSizeMake(3, 3)];
//    }
//    return _pageControl;
//}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    ABWalkthroughScrollDirection scrollDirection;
//    CGFloat multiplier = 1.0;
//    CGFloat width = getFrameWidth(self);
//    
//    CGFloat offset = scrollView.contentOffset.x;
//    
//    if (self.lastContentOffset > offset) {
//        scrollDirection = ABWalkthroughScrollDirectionRight;
//        if (self.pageControl.currentPage > 0)  {
//            if (offset > (self.pageControl.currentPage - 1) * width) {
//                self.otherPageNumber = self.pageControl.currentPage + 1;
//                multiplier = 1.0;
//            } else {
//                self.otherPageNumber = self.pageControl.currentPage - 1;
//                multiplier = -1.0;
//            }
//        }
//    } else if (self.lastContentOffset < offset) {
//        scrollDirection = ABWalkthroughScrollDirectionLeft;
//        if (offset < (self.pageControl.currentPage - 1) * width) {
//            self.otherPageNumber = self.pageControl.currentPage - 1;
//            multiplier = -1.0;
//        } else {
//            self.otherPageNumber = self.pageControl.currentPage + 1;
//            multiplier = 1.0;
//        }
//    }
//    
//    self.lastContentOffset = offset;
//    
//    UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.pageControl.currentPage + 1) * 10];
//    UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber + 1) * 10];
//    
//    if (internalScrollView) {
//        NSAssert([internalScrollView isKindOfClass:[UIScrollView class]], @"internalScrollView must be of class UIScrollView");
//        internalScrollView.contentOffset = CGPointMake(-ABPercentageMultiplier * (offset - (width * self.pageControl.currentPage)), 0.0f);
//    }
//    
//    if (otherScrollView) {
//        otherScrollView.contentOffset = CGPointMake(multiplier * ABPercentageMultiplier * width - (ABPercentageMultiplier * (offset - (width * self.pageControl.currentPage))), 0.0f);
//        NSAssert([otherScrollView isKindOfClass:[UIScrollView class]], @"otherScrollView must be of class UIScrollView");
//    }
//    
//    // Update the page when more than 50% of the previous/next page is visible
//    NSInteger page = self.scrollView.contentOffset.x / getFrameWidth(self);
//    [self.pageControl setCurrentPage:(int)page];
//    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
//        [(ABInterface *)self.viewControllers[self.pageControl.currentPage] showButtons];
//    }
//}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    UIScrollView *internalScrollView = (UIScrollView *)[scrollView viewWithTag:(self.pageControl.currentPage + 1) * 10];
//    UIScrollView *otherScrollView = (UIScrollView *)[scrollView viewWithTag:(self.otherPageNumber + 1) * 10];
//    
//    NSAssert([internalScrollView isKindOfClass:[UIScrollView class]], @"internalScrollView must be of class UIScrollView");
//    NSAssert([otherScrollView isKindOfClass:[UIScrollView class]], @"otherScrollView must be of class UIScrollView");
//    
//    internalScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
//    otherScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
//    
//    NSInteger page = self.scrollView.contentOffset.x / getFrameWidth(self);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewController:didScrollToSlideWithTag:)]) {
//        [self.delegate walkthroughViewController:self didScrollToSlideWithTag:page];
//    }
//}

#pragma mark - Accessors

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]
                                   initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                   options:nil];
        NSParameterAssert(self.childrenStoryboardIds);
        UIViewController *firstViewController = [self.storyboard
                                                 instantiateViewControllerWithIdentifier:self.childrenStoryboardIds[0]];
        NSParameterAssert(firstViewController);
        [_pageViewController setViewControllers:@[firstViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];

        [_pageViewController setDelegate:self];
        [_pageViewController setDataSource:self];
    }
    return _pageViewController;
}

- (void)setChildrenStoryboardIds:(NSArray *)childrenStoryboardIds
{
    NSParameterAssert(childrenStoryboardIds);
    NSAssert([childrenStoryboardIds count] > 0, @"Must provide at least one storyboard ID");
    
    _childrenStoryboardIds = childrenStoryboardIds;

}

#pragma mark - ABInterfaceDelegate
//- (void)didPressButton:(ABInterface *)interface
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(walkthroughViewController:didPressButtonWithTag:)]) {
//        [self.delegate walkthroughViewController:self didPressButtonWithTag:interface.tag];
//    }
//}

#pragma mark - Effects
- (void)setRounderCorners:(BOOL)rounderCorners
{
    if (rounderCorners) {
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = YES;
    } else {
        self.view.layer.cornerRadius = 1;
        self.view.layer.masksToBounds = NO;
    }
}

#pragma mark - Animation
//- (void)performInitialAnimation
//{
//    CGPoint initialOffset = self.scrollView.contentOffset;
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.scrollView setContentOffset:CGPointMake(initialOffset.x + 50, initialOffset.y)];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.scrollView setContentOffset:initialOffset];
//        } completion:nil];
//    }];
//}

#pragma mark - Notif
- (void)videoLoadedNotification:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.delegate walkthroughViewControllerDidFinishLoadingVideos:self];
}

@end
