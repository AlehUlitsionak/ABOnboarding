//
//  ABVideoLoopViewController.m
//  Pods
//
//  Created by Alejandro Benito Santos on 21/04/2015.
//
//

#import "ABVideoLoopViewController.h"
#import "ABOnboardingViewController.h"
#import <AVAnimator/AVAnimatorMedia.h>
#import <AVAnimator/AVAnimatorLayer.h>
#import <AVAsset2MvidResourceLoader.h>
#import <AVMvidFrameDecoder.h>
#import <AVFileUtil.h>

@interface ABVideoLoopViewController ()

@property (strong, nonatomic) AVAnimatorLayer *animatorLayer;
@property (strong, nonatomic) AVAnimatorMedia *media;

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) CGFloat textDistance;

@end


@implementation ABVideoLoopViewController

- (instancetype)initWithText:(NSString *)text andDistanceToTopLayoutGuide:(CGFloat)textDistance
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _text = text;
        _textDistance = textDistance;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.videoFileName, @"Video file name must be set in Interface Builder before using this class");
//    [self.view layoutIfNeeded];
    
//    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 270, 45.0)];
//    [self.textLabel setTextColor:[UIColor whiteColor]];
//    [self.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
//    [self.textLabel setText:self.text];
//
//    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.textLabel.numberOfLines = 0;
//    
//    CGRect textBounds = [self.text boundingRectWithSize:(CGSize){270, DBL_MAX }
//                                              options:NSStringDrawingUsesLineFragmentOrigin | NSLineBreakByWordWrapping
//                                           attributes:@{NSFontAttributeName: self.textLabel.font}
//                                              context:nil];
//    [self.textLabel setPreferredMaxLayoutWidth:textBounds.size.width];
//    
//    [self.textLabel setFrame:CGRectMake(0, 0, textBounds.size.width, textBounds.size.height)];
    
    [self prepareVideo];
//    [self.view addSubview:self.textLabel];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:ABMotionFrameOffset / 2.0f]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.textDistance]];
//    
//    [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ceilf(textBounds.size.width + 1)]];
//    
//    [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ceilf(textBounds.size.height)]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.media startAnimator];
}

- (void)prepareVideo
{
    CALayer *mainLayer = self.videoPlayerView.layer;
    CALayer *renderLayer = [[CALayer alloc] init];
    
    renderLayer.backgroundColor = [UIColor whiteColor].CGColor;
    renderLayer.masksToBounds = YES;
    
    CGRect rendererFrame = self.videoPlayerView.layer.frame;
    renderLayer.frame = rendererFrame;
    
    renderLayer.position = CGPointMake(CGRectGetMidX(rendererFrame), CGRectGetMidY(rendererFrame));
    [mainLayer addSublayer:renderLayer];
    
    AVAnimatorLayer *avAnimatorLayer = [AVAnimatorLayer aVAnimatorLayer:renderLayer];
    
    self.media = [AVAnimatorMedia aVAnimatorMedia];
    
    AVAsset2MvidResourceLoader *resLoader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
    
    
    NSString *tmpFileName = [[self.videoFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"mvid"];
    NSString *tmpPath = [AVFileUtil getTmpDirPath:tmpFileName];
    
    resLoader.movieFilename = self.videoFileName;
    resLoader.outPath = tmpPath;
    
    self.media.resourceLoader = resLoader;
    self.media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
    
    self.media.animatorRepeatCount = INT_MAX;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatorDoneNotification:) name:AVAnimatorDoneNotification object:self.media];
    
    [avAnimatorLayer attachMedia:self.media];
    
    self.animatorLayer = avAnimatorLayer;
    
    [self.media prepareToAnimate];
}


- (void)animatorDoneNotification:(NSNotification*)notification {
    NSLog( @"animatorDoneNotification" );
    
    // Unlink all notifications
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [self stopAnimator];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self.animatorLayer.layer setFrame:self.videoPlayerView.layer.frame];
    
    CGRect rendererFrame = self.videoPlayerView.layer.bounds;
    self.animatorLayer.layer.frame = rendererFrame;
//    self.animatorLayer.layer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.ani), <#CGFloat height#>)
//    self.animatorLayer.layer.position = CGPointMake(CGRectGetMidX(rendererFrame), CGRectGetMidY(rendererFrame));
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
