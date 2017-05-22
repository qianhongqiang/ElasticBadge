//
//  EBGAnimationView.m
//  Pods
//
//  Created by qianhongqiang on 2017/5/16.
//
//

#import "EBGAnimationView.h"

static CGFloat kFromRadiusScaleCoefficient = 0.09f;
static CGFloat kToRadiusScaleCoefficient = 0.05f;
static CGFloat kMaxDistanceScaleCoefficient = 8.f;

@interface EBGAnimationView()

@property (nonatomic, assign) float fromRadius;
@property (nonatomic, assign) float toRadius;

@property (nonatomic, assign) float viscosity;

@property (nonatomic, assign) float currentDistance;

@property (nonatomic, assign) EBGAnimationViewState currentState;

@end

@implementation EBGAnimationView

#pragma mark - setter
-(void)setOringinCenter:(CGPoint)oringinCenter
{
    _oringinCenter = oringinCenter;
    _currentMovingPoint = oringinCenter;
    
    [self setNeedsDisplay];
}

-(void)setCurrentMovingPoint:(CGPoint)currentMovingPoint
{
    _currentMovingPoint = currentMovingPoint;
    
    self.currentDistance = distanceBetweenPoints(_oringinCenter, _currentMovingPoint);
    
    [self updateRadius];
    [self setNeedsDisplay];
}

-(void)setCurrentDistance:(float)currentDistance
{
    _currentDistance = currentDistance;
    if (_currentDistance > _maxDistance) {
        _currentState = EBGAnimationViewStateSeperated;
    }
}

-(void)setRadius:(float)radius
{
    _radius = radius;
    _maxDistance = kMaxDistanceScaleCoefficient * _radius;
}

#pragma mark drawCode
- (void)drawRect:(CGRect)rect {
    if (_maxDistance < _currentDistance || _currentState == EBGAnimationViewStateSeperated) {//分离
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
        CGContextAddArc(ctx, _currentMovingPoint.x, _currentMovingPoint.y, 10, 0, 2 * M_PI, YES);
        CGContextFillPath(ctx);
        
        BOOL isOverFlow = self.badgeNumber > 99;
        
        NSMutableParagraphStyle *paragraphMaking = [[NSMutableParagraphStyle alloc] init];
        paragraphMaking.alignment = NSTextAlignmentCenter;
        NSString *titleMaking = isOverFlow ? @"99+" : [NSString stringWithFormat:@"%d",self.badgeNumber];
        NSDictionary *attributesMaking = @{
                                           NSParagraphStyleAttributeName:paragraphMaking,
                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:isOverFlow ? 10: 15],
                                           NSForegroundColorAttributeName:self.badgeTextColor,
                                           };
        float offset = isOverFlow ? 3 : 0;
        [titleMaking drawInRect:CGRectMake(_currentMovingPoint.x - 10, _currentMovingPoint.y - 10 +offset, 20, 20) withAttributes:attributesMaking];
        
    }else{//未分离
        
        UIBezierPath* path = [self bezierPathWithFromPoint:_oringinCenter toPoint:_currentMovingPoint fromRadius:_fromRadius toRadius:_toRadius scale:_viscosity];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
        CGContextAddPath(ctx, path.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
    }
}
#pragma mark - public
-(void)clearViewState
{
    self.currentState = EBGAnimationViewStateConnect;
}

#pragma mark - private
- (void)updateRadius {
    CGFloat r = distanceBetweenPoints(_oringinCenter, _currentMovingPoint);
    
    self.fromRadius = self.radius-kFromRadiusScaleCoefficient*r;
    self.toRadius = self.radius-kToRadiusScaleCoefficient*r;
    self.viscosity = 1.0-r/_maxDistance;
    
    [self setNeedsDisplay];
}

- (UIBezierPath* )bezierPathWithFromPoint:(CGPoint)fromPoint
                                  toPoint:(CGPoint)toPoint
                               fromRadius:(CGFloat)fromRadius
                                 toRadius:(CGFloat)toRadius
                                    scale:(CGFloat)scale
{
    CGFloat r = distanceBetweenPoints(fromPoint, toPoint);
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    CGFloat offsetY = fabs(fromRadius-toRadius);
    if (r <= offsetY) {
        CGPoint center;
        CGFloat radius;
        if (fromRadius >= toRadius) {
            center = fromPoint;
            radius = fromRadius;
        } else {
            center = toPoint;
            radius = toRadius;
        }
        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    } else {
        CGFloat originX = toPoint.x - fromPoint.x;
        CGFloat originY = toPoint.y - fromPoint.y;
        
        CGFloat fromOriginAngel = (originX >= 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat fromOffsetAngel = (fromRadius >= toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat fromStartAngel = fromOriginAngel + fromOffsetAngel;
        CGFloat fromEndAngel = fromOriginAngel - fromOffsetAngel;
        
        CGPoint fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
        
        CGFloat toOriginAngel = (originX < 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat toOffsetAngel = (fromRadius < toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat toStartAngel = toOriginAngel + toOffsetAngel;
        CGFloat toEndAngel = toOriginAngel - toOffsetAngel;
        CGPoint toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
        
        CGPoint middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
        CGFloat middleRadius = (fromRadius+toRadius)/2;
        
        CGPoint fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
        
        CGPoint toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
        
        [path moveToPoint:fromStartPoint];
        
        [path addArcWithCenter:fromPoint radius:fromRadius startAngle:fromStartAngel endAngle:fromEndAngel clockwise:YES];
        
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:toStartPoint controlPoint:fromControlPoint];
        }
        
        [path addArcWithCenter:toPoint radius:toRadius startAngle:toStartAngel endAngle:toEndAngel clockwise:YES];
        
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:fromStartPoint controlPoint:toControlPoint];
        }
    }
    
    [path closePath];
    
    return path;
}

#pragma mark - getter
-(UIColor *)borderColor
{
    if (!_borderColor) {
        _borderColor = [UIColor redColor];
    }
    return _borderColor;
}

-(UIColor *)badgeTextColor
{
    if (!_badgeTextColor) {
        _badgeTextColor = [UIColor whiteColor];
    }
    return _badgeTextColor;
}

@end
