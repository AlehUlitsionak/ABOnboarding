//
//  ABVideoLoopViewController.h
//  Pods
//
//  Created by Alejandro Benito Santos on 21/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface ABVideoLoopViewController : UIViewController

@property (strong, nonatomic) NSString *resFileName;
@property (strong, nonatomic) UILabel *textLabel;


- (instancetype)initWithText:(NSString *)text andDistanceToTopLayoutGuide:(CGFloat)textDistance;

@end
