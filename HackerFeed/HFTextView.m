//
//  HFTextView.m
//  HackerFeed
//
//  Created by Nealon Young on 1/30/14.
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//

#import "HFTextView.h"

@interface HFTextView ()

@property (nonatomic) NSAttributedString *attributedPlaceholder;

- (void)textChanged:(NSNotification *)notification;
- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end

@implementation HFTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.font = [UIFont applicationFontOfSize:15.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    self.scrollEnabled = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, [self sizeThatFits:CGSizeMake(self.frame.size.width * 1.0f, CGFLOAT_MAX)].height);
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
	// Draw placeholder text if necessary
	if (self.text.length == 0 && self.attributedPlaceholder) {
		CGRect placeholderRect = [self placeholderRectForBounds:self.bounds];
		[self.attributedPlaceholder drawInRect:placeholderRect];
	}
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    
	if ([self respondsToSelector:@selector(textContainer)]) {
		rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
		CGFloat padding = self.textContainer.lineFragmentPadding;
		rect.origin.x += padding;
		rect.size.width -= padding * 2.0f;
	} else {
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
	}
    
	return rect;
}

- (NSString *)placeholder {
	return self.attributedPlaceholder.string;
}

- (void)setPlaceholder:(NSString *)string {
	if ([string isEqualToString:self.attributedPlaceholder.string]) {
		return;
	}
    
	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	if ([self isFirstResponder] && self.typingAttributes) {
		[attributes addEntriesFromDictionary:self.typingAttributes];
	} else {
		attributes[NSFontAttributeName] = self.font;
		attributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.702f alpha:1.0f];
        
		if (self.textAlignment != NSTextAlignmentLeft) {
			NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
			paragraph.alignment = self.textAlignment;
			attributes[NSParagraphStyleAttributeName] = paragraph;
		}
	}
    
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
	[super setContentInset:contentInset];
	[self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
	[super setFont:font];
	[self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	[self setNeedsDisplay];
}

- (void)textChanged:(NSNotification *)notification {
	[self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

@end
