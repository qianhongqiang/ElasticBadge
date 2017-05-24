//
//  EBGElasticBadge.m
//  Pods
//
//  Created by qianhongqiang on 2017/5/16.
//
//

#import "EBGElasticBadge.h"
#import "EBGAnimationView.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define LAST_WINDOW [[UIApplication sharedApplication].windows lastObject]

static CGFloat kBadgeBorderLength = 20.f;


@interface EBGElasticBadge()

/**
 实际展示绘制动画的页面
 */
@property (nonatomic, strong) EBGAnimationView *liquidAnimationView;

/**
 消失时的回调
 */
@property (nonatomic, copy) void(^dismissCallBackBlock)(EBGElasticBadge *liquidButton);

@property (nonatomic, assign) CGPoint touchesStartPoint;

@end

@implementation EBGElasticBadge

#pragma mark - initMethod
-(instancetype)initWithLocationCenter:(CGPoint)center
                          bagdeNumber:(int)badgeNumber
                  willDismissCallBack:(void (^)(EBGElasticBadge *))dismiss
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kBadgeBorderLength, kBadgeBorderLength);
        self.center = center;
        self.layer.cornerRadius = kBadgeBorderLength * 0.5f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        
        _badgeNumber = badgeNumber;
        
        _dismissCallBackBlock = dismiss;
        
        //添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark - gesture
-(void)gestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:LAST_WINDOW];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.hidden = YES;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:self.liquidAnimationView];
            CGPoint originCenter = [self convertPoint:CGPointMake(kBadgeBorderLength * 0.5f, kBadgeBorderLength * 0.5f) toView:(UIWindow *)LAST_WINDOW];
            self.touchesStartPoint = currentPoint;
            self.liquidAnimationView.oringinCenter = originCenter;
            self.liquidAnimationView.radius = kBadgeBorderLength * 0.5f;
            self.liquidAnimationView.badgeNumber = self.badgeNumber;
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
            if (distanceBetweenPoints(self.touchesStartPoint, currentPoint) > self.liquidAnimationView.radius * 8) {
                if (self.dismissCallBackBlock) {
                    self.dismissCallBackBlock(self);
                }
                [self.liquidAnimationView removeFromSuperview];
                [self removeFromSuperview];
            }else {
                [self.liquidAnimationView removeFromSuperview];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.hidden = NO;
            [self.liquidAnimationView removeFromSuperview];
        }
            break;
            
            
        default:
            break;
    }
}

-(void)drawRect:(CGRect)rect {
    NSMutableParagraphStyle *paragraphMaking = [[NSMutableParagraphStyle alloc] init];
    paragraphMaking.alignment = NSTextAlignmentCenter;
    BOOL isOverFlow = self.badgeNumber > 99;
    NSString *titleMaking = isOverFlow ? @"99+" : [NSString stringWithFormat:@"%d",self.badgeNumber];
    NSDictionary *attributesMaking = @{
                                       NSParagraphStyleAttributeName:paragraphMaking,
                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:isOverFlow ? 10: 15],
                                       NSForegroundColorAttributeName:self.badgeTextColor ? : [UIColor whiteColor],
                                       };
    [titleMaking drawInRect:CGRectMake(0, isOverFlow ? 3 : 1, rect.size.width, rect.size.height - 6) withAttributes:attributesMaking];
}

#pragma mark - getter & setter
- (EBGAnimationView *)liquidAnimationView
{
    if (!_liquidAnimationView) {
        _liquidAnimationView = [[EBGAnimationView alloc] initWithFrame:KEY_WINDOW.bounds];
        _liquidAnimationView.backgroundColor = [UIColor clearColor];
    }
    return _liquidAnimationView;
}

- (void)setBadgeNumber:(int)badgeNumber
{
    _badgeNumber = badgeNumber;
    [self setNeedsDisplay];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    _badgeBackgroundColor = badgeBackgroundColor;
    self.backgroundColor = badgeBackgroundColor;
    [self.liquidAnimationView setBorderColor:badgeBackgroundColor];
    [self setNeedsDisplay];
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    [self.liquidAnimationView setBadgeTextColor:badgeTextColor];
    [self setNeedsDisplay];
    
}

@end
