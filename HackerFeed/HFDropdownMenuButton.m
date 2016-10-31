#import "HFDropdownMenuButton.h"
#import "UIColor+HFAdditions.h"

@interface HFDropdownMenuButton ()

@property UIView *bottomBorderView;

- (void)applyTheme;

@end

@implementation HFDropdownMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.selected = NO;

        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        self.iconImageView = [[UIImageView alloc] initWithImage:nil];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];
        
        self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.bottomBorderView];
        
        [self applyTheme];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeChangedNotificationName object:nil];
    }
    
    return self;
}

- (instancetype)initWithItem:(HFDropdownMenuItem *)item {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setTitle:item.title forState:UIControlStateNormal];
        //self.iconImageView.image = item.image;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(15.0f, 0, 30.0f, CGRectGetHeight(self.frame));
    
    self.bottomBorderView.frame = CGRectMake(16.0f,
                                             CGRectGetHeight(self.frame),
                                             CGRectGetWidth(self.frame) - 32.0f,
                                             1.0f / [UIScreen mainScreen].scale);
}

- (UIColor *)titleColorForCurrentSelectionState {
    return !self.selected ? [HFInterfaceTheme activeTheme].textColor : [[HFInterfaceTheme activeTheme].textColor hf_colorLightenedByFactor:0.2f];
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected];

    CGFloat scaleFactor = selected ? 1.0f : 0.9f;

    void (^selectionBlock)() = ^{
        self.titleLabel.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    };

    if (animated) {
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:selectionBlock
                         completion:nil];
    } else {
        selectionBlock();
    }
}

- (void)applyTheme {
    self.iconImageView.tintColor = [[HFInterfaceTheme activeTheme] accentColor];
    self.bottomBorderView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    self.bottomBorderView.backgroundColor = [[HFInterfaceTheme activeTheme].backgroundColor hf_colorDarkenedByFactor:0.06f];
    [self setTitleColor:[HFInterfaceTheme activeTheme].textColor forState:UIControlStateSelected];
    [self setTitleColor:[[HFInterfaceTheme activeTheme].textColor hf_colorLightenedByFactor:0.2f] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont semiboldApplicationFontOfSize:16.0f];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangedNotificationName object:nil];
}

@end
