//
//  UIButton+Animation.m
//  mento
//
//  Created by Alejandro Benito on 12/05/2015.
//  Copyright (c) 2015 Aurora Software. All rights reserved.
//

/* #define taken from http://ios-blog.co.uk/tutorials/cleaner-properties-implementation-in-categories/ */

/* generic applicable to all objects and primitive types */

#define JESynthesize(ownership, type, getter, setter) \
static const void *_JESynthesizeKey_##getter = &_JESynthesizeKey_##getter; \
- (type)getter \
{ \
return _JESynthesize_get_##ownership(type, getter); \
} \
- (void)setter:(type)getter \
{ \
_JESynthesize_set_##ownership(type, getter); \
}

/* Specific to primitive types like BOOL, int */

#define _JESynthesize_get_assign(type, getter) \
({ \
typeof(type) _je_value[1] = {}; \
[(NSValue *)objc_getAssociatedObject(self, _JESynthesizeKey_##getter) getValue:_je_value]; \
_je_value[0]; \
})

#define _JESynthesize_set_assign(type, getter) \
objc_setAssociatedObject(self, \
_JESynthesizeKey_##getter, \
[[NSValue alloc] initWithBytes:&getter objCType:@encode(type)], \
OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#import "UIButton+Animation.h"
#import <POP.h>
#import <objc/runtime.h>

@implementation UIButton (Animation)

JESynthesize(assign, BOOL, animateOnAppear, setAnimateOnAppear);
JESynthesize(assign, BOOL, animateOnTap, setAnimateOnTap);

-(void)awakeFromNib{
    if(self.animateOnAppear){
        [self bounce];
    }
    if(self.animateOnTap){
        [self addTarget:self action:@selector(scaleToSmall)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(bounce)
       forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit | UIControlEventTouchDragOutside];
    }
}

- (void)scaleToSmall{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    scaleAnimation.duration = 0.1;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)bounce{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}


@end
