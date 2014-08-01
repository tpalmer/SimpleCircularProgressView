//
//  CircularProgressView.m
//  hltcore
//
//  Created by Travis Palmer on 11/6/13.
//  Copyright (c) 2013 HLT. All rights reserved.
//

#import "CircularProgressView.h"

#define kLineWidth 3
#define kPadding 5

@implementation CircularProgressView

- (void)awakeFromNib {
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressLabel.font = [UIFont fontWithName:@"Avenir-Light" size:40];
    self.progressLabel.text = @"0";
    self.progressLabel.backgroundColor = [UIColor clearColor];
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.alpha = self.alpha;

    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.percentLabel.font = [UIFont fontWithName:@"Avenir-Light" size:28];
    self.percentLabel.text = @"%";
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.textColor = [UIColor whiteColor];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.alpha = self.alpha;

    self.correctLabel = [[UILabel alloc] init];
    self.correctLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.correctLabel.font = [UIFont fontWithName:@"Avenir Medium" size:14];
    self.correctLabel.text = @"CORRECT";
    self.correctLabel.backgroundColor = [UIColor clearColor];
    self.correctLabel.textColor = [CircularProgressView blueColor:1];
    self.correctLabel.textAlignment = NSTextAlignmentCenter;
    self.correctLabel.alpha = self.alpha;

    [self addSubview:self.progressLabel];
    [self addSubview:self.percentLabel];
    [self addSubview:self.correctLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentValue = 0.0;
        self.newValue = 0.0;
        self.isAnimationInProgress = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code.
    [self renderCircularView];

}

- (void)updateConstraints {

    // Add a constraint for the X of the progress label.
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.progressLabel
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:-10];
    [self addConstraint:centerXConstraint];

    // Add a constraint for the Y of the progress label.
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.progressLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:-10];
    [self addConstraint:centerYConstraint];

    // Add a constraints for the percent label.
    NSArray *percentConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_progressLabel]-5-[_percentLabel]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_progressLabel, _percentLabel)];
    [self addConstraints:percentConstraint];

    NSLayoutConstraint *percentCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.percentLabel
                                                                                attribute:  NSLayoutAttributeCenterY
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self
                                                                                attribute:  NSLayoutAttributeCenterY
                                                                               multiplier:1.0
                                                                                 constant:-6];
    [self addConstraint:percentCenterYConstraint];

    // Add a constraints for the 'correct' label.
    NSArray *correctConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressLabel]-(-10)-[_correctLabel]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(_progressLabel, _correctLabel)];
    [self addConstraints:correctConstraint];

    NSLayoutConstraint *correctCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.correctLabel
                                                                                attribute:NSLayoutAttributeCenterX
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self
                                                                                attribute:NSLayoutAttributeCenterX
                                                                               multiplier:1.0
                                                                                 constant:0];
    [self addConstraint:correctCenterXConstraint];

    [super updateConstraints];

}

- (void)updateLabelWithValue:(NSString*)value
{
    self.progressLabel.text = value;
}

- (void)setProgressValue:(float)to_value withAnimationTime:(float)animation_time
{
    float timer = 0;

    float step = 0.1;

    float value_step = (to_value - self.self.currentValue) * step / animation_time;
    int final_value = self.currentValue * 100;

    while (timer < animation_time - step) {
        final_value += floor(value_step * 100);
        [self performSelector:@selector(updateLabelWithValue:) withObject:[NSString stringWithFormat:@"%i", final_value] afterDelay:timer];
        timer += step;
    }

    [self performSelector:@selector(updateLabelWithValue:) withObject:[NSString stringWithFormat:@"%.0f", to_value * 100] afterDelay:animation_time];
}

- (void)setAnimationDone
{
    self.isAnimationInProgress = NO;
    if (self.newValue > self.currentValue) {
        [self renderCircularView];
    }

    [self setProgress:self.newValue];
}

- (void)setProgress:(float)value
{
    self.toValue = value;
    [self setNeedsDisplay];
}

- (void)renderCircularView
{

    if (self.toValue <= self.currentValue) {
        return;

    } else if (self.toValue > 1.0) {
        self.toValue = 1.0;

    }

    if (self.isAnimationInProgress) {
        self.newValue = self.toValue;
        return;
    }

    self.isAnimationInProgress = YES;

    float animation_time = self.toValue - self.currentValue;

    [self performSelector:@selector(setAnimationDone) withObject:Nil afterDelay:animation_time];

    if (self.toValue == 1.0 && self.delegate && [self.delegate respondsToSelector:@selector(didFinishAnimation:)]) {

        [self.delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:animation_time];
    }

    [self setProgressValue:self.toValue withAnimationTime:animation_time];

    float start_angle = 2 * M_PI * self.currentValue - M_PI_2;
    float end_angle = 2 * M_PI * self.toValue - M_PI_2;
    CGFloat width = self.frame.size.width / 2;
    CGFloat height = self.frame.size.height / 2;
    int padding = [CircularProgressView isRetina] ? (kPadding * 2) : kPadding;
    float radius = (self.frame.size.width - padding) / 2;
    int line_width = kLineWidth; // [Util isRetina] ? (kLineWidth * 2) : kLineWidth;

    CAShapeLayer *circle = [CAShapeLayer layer];
    CAShapeLayer *underCircle = [CAShapeLayer layer];

    // Make a circular shape.
    circle.path = [CircularProgressView circlePathWithStartAngle:start_angle
                                       end_angle:end_angle
                                           width:width
                                          height:height
                                          radius:radius].CGPath;

    underCircle.path = [CircularProgressView circlePathWithStartAngle:0
                                            end_angle:(2 * M_PI)
                                                width:width
                                               height:height
                                               radius:radius].CGPath;

    // Set the appearance of the circle.
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [CircularProgressView blueColor:1].CGColor;
    circle.lineCap = kCALineCapRound;
    circle.lineWidth = line_width;
    underCircle.fillColor = [UIColor clearColor].CGColor;
    underCircle.strokeColor = [CircularProgressView backgroundColor].CGColor;
    underCircle.lineWidth = line_width;

    // Add to parent layer.
    [self.layer addSublayer:underCircle];
    [self.layer addSublayer:circle];

    // Initialize animation.
    CABasicAnimation *underAnimation = [CABasicAnimation animationWithKeyPath:@"underStrokeEnd"];
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    underAnimation.duration            = 0.0;
    underAnimation.repeatCount         = 0.0;
    underAnimation.removedOnCompletion = NO;
    drawAnimation.duration             = animation_time;
    drawAnimation.repeatCount          = 0.0;  // Animate only once.
    drawAnimation.removedOnCompletion  = NO;   // Remain stroked after the animation.

    // Animate from no part of the stroke being drawn to the entire stroke being drawn.
    underAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    underAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    drawAnimation.fromValue  = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue    = [NSNumber numberWithFloat:1.0];

    // Define animation timing.
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    // Add the animation to the circle.
    [underCircle addAnimation:underAnimation forKey:@"drawUnderCircleAnimation"];
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];

    self.currentValue = self.toValue;
}

+ (UIColor *)blueColor:(CGFloat)alpha {

    return [UIColor colorWithRed:153.0 / 255.0
                           green:207.0 / 255.0
                            blue:200.0 / 255.0
                           alpha:alpha];

}

+ (BOOL) isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

+ (UIBezierPath *)circlePathWithStartAngle:(float)start_angle
                                 end_angle:(float)end_angle
                                     width:(CGFloat)width
                                    height:(CGFloat)height
                                    radius:(float)radius
{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width,height)
                                          radius:radius
                                      startAngle:start_angle
                                        endAngle:end_angle
                                       clockwise:YES];
}

+ (UIColor *)backgroundColor {

    return [UIColor colorWithRed:0.0 / 255.0
                           green:0.0 / 255.0
                            blue:0.0 / 255.0
                           alpha:0.08];

}

@end
