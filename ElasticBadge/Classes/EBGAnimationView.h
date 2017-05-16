//
//  EBGAnimationView.h
//  Pods
//
//  Created by qianhongqiang on 2017/5/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EBGAnimationViewState) {
    EBGAnimationViewStateUnknown  = 0,   //未知状态
    EBGAnimationViewStateConnect  = 1,     //处于粘连状态
    EBGAnimationViewStateSeperated = 2,    //处于分离状态，当分离后，距离靠近之后，并不会再度粘连
};

static inline CGFloat distanceBetweenPoints (CGPoint pointA, CGPoint pointB) {
    CGFloat deltaX = pointB.x - pointA.x;
    CGFloat deltaY = pointB.y - pointA.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
};

@interface EBGAnimationView : UIView

@property (nonatomic, assign) int badgeNumber;

@property (nonatomic, assign) CGPoint oringinCenter;  //初始点
@property (nonatomic, assign) CGPoint currentMovingPoint;   //当前点

@property (nonatomic, assign, readonly) float maxDistance; //设置最大连接长度，当起始点与当前点的距离大于maxDistance后,那么就进去分离状态

@property (nonatomic, assign) float radius;

@property (nonatomic, strong) UIColor *borderColor;

-(void)clearViewState;

@end
