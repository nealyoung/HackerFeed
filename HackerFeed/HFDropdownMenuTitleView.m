#import "HFDropdownMenuTitleView.h"

@implementation HFDropdownMenuTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;
        self.accessibilityHint = NSLocalizedString(@"Toggles visibility of feed type menu", nil);

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        // Center the label in the view
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0.0f]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_titleLabel)]];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kThemeChangedNotificationName
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note) {
                                                          [self applyTheme];
                                                      }];
    }
    
    return self;
}

- (NSString *)accessibilityLabel {
    return self.titleLabel.text;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    [[HFInterfaceTheme activeTheme].accentColor setStroke];

    UIBezierPath *roundRectBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1.0f, 1.0f)
                                                                   cornerRadius:CGRectGetHeight(rect) / 2.0f];
    roundRectBezierPath.lineWidth = 1.0f;
    [roundRectBezierPath stroke];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(128, 32);
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    CATransform3D transform;
    
    if (expanded) {
        transform = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 0.0f);
    } else {
        transform = CATransform3DIdentity;
    }
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         self.indicator.layer.transform = transform;
                     }
                     completion:nil];
}

- (void)applyTheme {
    [self setNeedsDisplay];

    self.titleLabel.font = [UIFont semiboldApplicationFontOfSize:17.0f];
    self.titleLabel.textColor = [[HFInterfaceTheme activeTheme] accentColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
