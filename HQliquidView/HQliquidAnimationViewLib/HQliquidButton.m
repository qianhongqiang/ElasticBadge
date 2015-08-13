//
//  HQliquidButton.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "HQliquidButton.h"
#import "HQliquidAnimationView.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define LAST_WINDOW [[UIApplication sharedApplication].windows lastObject]


@interface HQliquidButton()

@property (nonatomic, strong) UILabel *badgeLabel; //用于展示数字

@property (nonatomic, strong) HQliquidAnimationView *liquidAnimationView; //用于展示数字

@end

@implementation HQliquidButton

#pragma mark - initMethod
-(instancetype)initWithLocationCenter:(CGPoint)center bagdeNumber:(int)badgeNumber
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 20, 20);
        self.center = center;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        
        _bagdeNumber = badgeNumber;
        
        [self addSubview:self.badgeLabel];
        [self updateBagdeNumber:badgeNumber];
        
        //添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - private
-(void)updateBagdeNumber:(int)bagdeNumber
{
    _bagdeNumber = bagdeNumber;
    if (bagdeNumber < 100) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",bagdeNumber];
    }else{
        self.badgeLabel.text = @"99+";
    }
}

#pragma mark - gesture
-(void)gestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:LAST_WINDOW];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.hidden = YES;
            NSLog(@"UIGestureRecognizerStateBegan");
            [[[UIApplication sharedApplication].windows lastObject] addSubview:self.liquidAnimationView];
            CGPoint originCenter = [self convertPoint:CGPointMake(10, 10) toView:(UIWindow *)LAST_WINDOW];
            self.liquidAnimationView.oringinCenter = originCenter;
            self.liquidAnimationView.radius = 10;
            self.liquidAnimationView.badgeNumber = self.bagdeNumber;
            [self.liquidAnimationView clearViewState];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.liquidAnimationView.currentMovingPoint = currentPoint;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.hidden = NO;
            NSLog(@"UIGestureRecognizerStateEnded");
            [self.liquidAnimationView removeFromSuperview];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.hidden = NO;
            NSLog(@"UIGestureRecognizerStateEnded");
            [self.liquidAnimationView removeFromSuperview];
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - getter & setter
-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _badgeLabel;
}

-(HQliquidAnimationView *)liquidAnimationView
{
    if (!_liquidAnimationView) {
        _liquidAnimationView = [[HQliquidAnimationView alloc] initWithFrame:KEY_WINDOW.bounds];
        _liquidAnimationView.backgroundColor = [UIColor clearColor];
    }
    return _liquidAnimationView;
}

@end
