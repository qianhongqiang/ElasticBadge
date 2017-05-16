//
//  EBGElasticBadge.h
//  Pods
//
//  Created by qianhongqiang on 2017/5/16.
//
//

#import <UIKit/UIKit.h>

@interface EBGElasticBadge : UIView

@property (nonatomic, assign, readonly) int bagdeNumber;
@property (nonatomic, strong) UIColor *HQ_textColor;

-(instancetype)initWithLocationCenter:(CGPoint)center
                          bagdeNumber:(int)badgeNumber
                  willDismissCallBack:(void(^)(EBGElasticBadge *liquidButton))dismiss;

@end
