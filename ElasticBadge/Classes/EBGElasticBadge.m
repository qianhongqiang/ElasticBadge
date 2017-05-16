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

typedef void(^willDismissCallBack)(EBGElasticBadge *liquidButton);


@interface EBGElasticBadge()

@property (nonatomic, strong) EBGAnimationView *liquidAnimationView; //用于展示数字

@property (nonatomic, copy) willDismissCallBack dismissCallBackBlock;

@property (nonatomic, assign) CGPoint touchesStartPotin;

@end

@implementation EBGElasticBadge

#pragma mark - initMethod
-(instancetype)initWithLocationCenter:(CGPoint)center
                          bagdeNumber:(int)badgeNumber
                  willDismissCallBack:(void (^)(EBGElasticBadge *))dismiss
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 20, 20);
        self.center = center;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        
        self.bagdeNumber = badgeNumber;
        
        self.dismissCallBackBlock = dismiss;
        
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
            CGPoint originCenter = [self convertPoint:CGPointMake(10, 10) toView:(UIWindow *)LAST_WINDOW];
            self.touchesStartPotin = currentPoint;
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
            if (distanceBetweenPoints(self.touchesStartPotin, currentPoint) > self.liquidAnimationView.radius * 8) {
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

#pragma mark - getter & setter

-(EBGAnimationView *)liquidAnimationView
{
    if (!_liquidAnimationView) {
        _liquidAnimationView = [[EBGAnimationView alloc] initWithFrame:KEY_WINDOW.bounds];
        _liquidAnimationView.backgroundColor = [UIColor clearColor];
    }
    return _liquidAnimationView;
}

- (void)setBagdeNumber:(int)bagdeNumber {
    _bagdeNumber = bagdeNumber;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    NSMutableParagraphStyle *paragraphMaking = [[NSMutableParagraphStyle alloc] init];
    paragraphMaking.alignment = NSTextAlignmentCenter;
    BOOL isOverFlow = self.bagdeNumber > 99;
    NSString *titleMaking = isOverFlow ? @"99+" : [NSString stringWithFormat:@"%d",self.bagdeNumber];
    NSDictionary *attributesMaking = @{
                                       NSParagraphStyleAttributeName:paragraphMaking,
                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:isOverFlow ? 10: 15],
                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                       };
    [titleMaking drawInRect:CGRectMake(0, isOverFlow ? 3 : 1, rect.size.width, rect.size.height - 6) withAttributes:attributesMaking];
}

@end
