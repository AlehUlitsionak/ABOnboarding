//
//  ABVideoLoopViewController.m
//  Pods
//
//  Created by Alejandro Benito Santos on 21/04/2015.
//
//

#import "ABVideoLoopViewController.h"
#import "ABOnboardingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ABVideoLoopViewController ()

//@property (strong, nonatomic) AVAnimatorLayer *animatorLayer;
//@property (strong, nonatomic) AVAnimatorMedia *media;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

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

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
////    [self.media startAnimator];
//
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

- (void)prepareVideo
{
    CALayer *mainLayer = self.videoPlayerView.layer;
    
    AVPlayerItem *playerItem = [AVPlayerItem
                                playerItemWithURL:[[NSBundle mainBundle]
                                                   URLForResource:self.videoFileName
                                                   withExtension:@"m4v"]];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
//    [_player addObserver:self forKeyPath:@"rate" options:0 context:NULL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = mainLayer.bounds;

    [mainLayer addSublayer:self.playerLayer];
    
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 100) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (CMTimeCompare(time, self.player.currentItem.duration) >= 0) {
            [strongSelf.player seekToTime:kCMTimeZero];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.player play];
            });
        }
    }];
    
//    AVAnimatorLayer *avAnimatorLayer = [AVAnimatorLayer aVAnimatorLayer:renderLayer];
//    
//    self.media = [AVAnimatorMedia aVAnimatorMedia];
//    
//    AVAsset2MvidResourceLoader *resLoader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
//    
//    
//    NSString *tmpFileName = [[self.videoFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"mvid"];
//    NSString *tmpPath = [AVFileUtil getTmpDirPath:tmpFileName];
//    
//    resLoader.movieFilename = self.videoFileName;
//    resLoader.outPath = tmpPath;
//    
//    self.media.resourceLoader = resLoader;
//    self.media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
//    
//    self.media.animatorRepeatCount = INT_MAX;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animatorDoneNotification:) name:AVAnimatorDoneNotification object:self.media];
//    
//    [avAnimatorLayer attachMedia:self.media];
//    
//    self.animatorLayer = avAnimatorLayer;
//    
//    [self.media prepareToAnimate];
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
    [self.playerLayer setFrame:self.videoPlayerView.layer.bounds];
    
//    CGRect rendererFrame = self.videoPlayerView.layer.bounds;
//    self.animatorLayer.layer.frame = rendererFrame;
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
