//
//  CircularProgressView.h
//  hltcore
//
//  Created by Travis Palmer on 11/6/13.
//  Copyright (c) 2013 HLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CircularProgressView : UIView

@property(nonatomic, strong) id delegate;
@property(nonatomic, assign) float currentValue;
@property(nonatomic, assign) float newValue;
@property(nonatomic, assign) float toValue;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UILabel *percentLabel;
@property(nonatomic, strong) UILabel *correctLabel;
@property(nonatomic, assign) BOOL isAnimationInProgress;

- (void)setProgress:(float)value;
- (void)updateLabelWithValue:(NSString*)value;
- (void)setProgressValue:(float)to_value withAnimationTime:(float)animation_time;
- (void)setAnimationDone;
- (void)renderCircularView;

@end

@protocol CircularProgressViewDelegate
- (void)didFinishAnimation:(CircularProgressView*)progressView;
@end
