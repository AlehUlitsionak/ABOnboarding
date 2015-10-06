//
//  MovieControlsView.h
//
//  Created by Moses DeJong on 4/11/09.
//
//  License terms defined in License.txt.

// This utility class exists to work around an issue with touch
// detection related to the hide controls timer. The view controller
// needed a way to detect when a touch event was detected for any
// subwindow since it needed to reset the hide controls timer when
// clicking in a subwindow. This class works around the issue by
// detecting a touch begin or end event via the hitTest method.

#import <UIKit/UIKit.h>

#import "MovieControlsViewController.h"

@interface MovieControlsView : UIView
{
	MovieControlsViewController *viewController;

	BOOL eventWasHandledInSubview;
}

// Assign ref but don't incr the ref count to avoid circular ref

@property (nonatomic, assign) MovieControlsViewController *viewController;

- (void) dealloc;

- (UIView *)hitTestSuper:(CGPoint)point withEvent:(UIEvent *)event;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end
