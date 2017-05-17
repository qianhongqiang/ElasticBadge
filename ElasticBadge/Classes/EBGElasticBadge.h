//
//  EBGElasticBadge.h
//  Pods
//
//  Created by qianhongqiang on 2017/5/16.
//
//

#import <UIKit/UIKit.h>

@interface EBGElasticBadge : UIView

@property (nonatomic, assign) int badgeNumber;
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic, strong) UIColor *badgeTextColor;

-(instancetype)initWithLocationCenter:(CGPoint)center
                          bagdeNumber:(int)badgeNumber
                  willDismissCallBack:(void(^)(EBGElasticBadge *liquidButton))dismiss;

@end
