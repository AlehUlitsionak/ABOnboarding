//
//  ABInterface.m
//  ABWalkthroughViewController
//
//  Created by Titouan Van Belle on 24/04/14.
//  Copyright (c) 2014 3dB. All rights reserved.
//

#import "ABInterface.h"
#import "UIButton+Animation.h"
#import "ABOnboardingViewController.h"

@interface ABInterface ()

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat textDistance;

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *imageView;
//@property (strong, nonatomic) IBOutlet UIButton *getStarted;
//@property (strong, nonatomic) IBOutlet UIButton *signIn;
//@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ABInterface

- (instancetype)initWithNibName:(NSString *)nibNameOrNil tag:(NSInteger)tag image:(UIImage *)image text:(NSString *)text andDistanceToTopLayoutGuide:(CGFloat)textDistance;
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _tag = tag;
        _image = image;
        _text = text;
        _textDistance = textDistance;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"NSInvalidInit" format:@"Must use the designated initialiser for this class"];
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:@"NSInvalidInit" format:@"Must use the designated initialiser for this class"];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 270, 45.0)];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
    [self.textLabel setText:self.text];
    //    [self.textLabel setCenter:self.textCenter];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    
    CGRect textBounds = [self.text boundingRectWithSize:(CGSize){270, DBL_MAX }
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSLineBreakByWordWrapping
                                             attributes:@{NSFontAttributeName: self.textLabel.font}
                                                context:nil];
    [self.textLabel setPreferredMaxLayoutWidth:textBounds.size.width];
    
//    [self.textLabel setFrame:CGRectMake(0, 0, textBounds.size.width, textBounds.size.height)];
    
    [self.view addSubview:self.textLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:ABMotionFrameOffset / 2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.textDistance]];
    
    [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ceilf(textBounds.size.width + 1)]];
    
    [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ceilf(textBounds.size.height)]];

    // imageview
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = self.image;
    
    // buttons
    self.button.hidden = YES;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.button.animateOnTap = YES;
    
    
    self.view.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)showButtons
{
    if (!self.button.hidden) {
        return;
    }
    
    self.button.hidden = NO;
    self.button.alpha = 0;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.button.alpha = 1;
                     }
                     completion:nil];
}

#pragma mark - actions

- (void)buttonPressed:(UIButton *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPressButton:)]) {
            [self.delegate didPressButton:self];
        }
    });
}

@end
