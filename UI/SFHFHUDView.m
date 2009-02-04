//
// SFHFHUDView.m
//
// Created by Buzz Andersen on 1/25/09.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "SFHFHUDView.h"


#define kSTATUS_LABEL_INSET_TOP		10.0
#define kSTATUS_LABEL_INSET_SIDES	5.0
#define kSTATUS_LABEL_HEIGHT		20.0

static UIColor *m_backgroundColor;
static UIColor *m_HUDColor;
static UIColor *m_statusLabelColor;
static UIFont *m_labelFont;

@implementation SFHFHUDView

@synthesize showsStatusLabel = m_showsStatusLabel;

+ (void) initialize {
	m_HUDColor = [[UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.6] retain];
	m_statusLabelColor = [[UIColor whiteColor] retain];
	m_labelFont = [[UIFont boldSystemFontOfSize: 14.0] retain];
	m_backgroundColor = [[UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.4] retain];
}

- (id) initWithFrame: (CGRect) frame {
	if (self = [super initWithFrame: frame]) {
		self.backgroundColor = m_backgroundColor;
		m_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		m_activityIndicator.hidesWhenStopped = NO;
		[self addSubview: m_activityIndicator];
		m_statusLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		m_statusLabel.textColor = m_statusLabelColor;
		m_statusLabel.font = m_labelFont;
		m_statusLabel.textAlignment = UITextAlignmentCenter;
		m_statusLabel.backgroundColor = [UIColor clearColor];
		[self addSubview: m_statusLabel];
 	}
	
	return self;
}

- (void) setShowsStatusLabel: (BOOL) showsStatusLabel {
	m_showsStatusLabel = showsStatusLabel;
	[self layoutSubviews];
}

- (void) layoutSubviews {
	CGRect frame = self.frame;

	CGFloat HUDWidth = 156.0;
	CGFloat HUDHeight = 124.0;

	CGFloat midX = CGRectGetMidX(frame);
	CGFloat midY = CGRectGetMidY(frame);
	
	CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
		
	m_HUDRect = CGRectMake(midX - (HUDWidth / 2), midY - ((HUDHeight / 2) + (statusBarRect.size.height * 2)), HUDWidth, HUDHeight);		

	CGRect statusLabelRect = CGRectZero;
	
	if (self.showsStatusLabel) {
		statusLabelRect = CGRectMake(m_HUDRect.origin.x + kSTATUS_LABEL_INSET_SIDES, m_HUDRect.origin.y + kSTATUS_LABEL_INSET_TOP, m_HUDRect.size.width - kSTATUS_LABEL_INSET_TOP * 2, kSTATUS_LABEL_HEIGHT);
	}
	
	m_statusLabel.frame = statusLabelRect;
	
	CGFloat HUDMidX = CGRectGetMidX(m_HUDRect);
	CGFloat HUDMidY = CGRectGetMidY(m_HUDRect);
	
	CGRect activityIndicatorFrame = m_activityIndicator.frame;
	CGFloat activityIndicatorWidth = activityIndicatorFrame.size.width;
	CGFloat activityIndicatorHeight = activityIndicatorFrame.size.height;
	activityIndicatorFrame.origin.x = ceil(HUDMidX - (activityIndicatorWidth / 2));
	activityIndicatorFrame.origin.y = ceil(HUDMidY - (activityIndicatorHeight / 2));
	
	if (self.showsStatusLabel) {
		activityIndicatorFrame.origin.y = activityIndicatorFrame.origin.y + kSTATUS_LABEL_INSET_TOP;
	}
	
	m_activityIndicator.frame = activityIndicatorFrame;
}

- (void) drawRect: (CGRect) rect {
	[super drawRect: rect];
	
	[m_HUDColor set];
	[self fillRoundedRect: m_HUDRect withCornerRadius: 10.0 inContext: UIGraphicsGetCurrentContext()];
}

- (void) fillRoundedRect: (CGRect) rect withCornerRadius: (CGFloat) cornerRadius inContext: (CGContextRef) context {
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + cornerRadius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - cornerRadius, CGRectGetMinY(rect) + cornerRadius, cornerRadius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - cornerRadius, CGRectGetMaxY(rect) - cornerRadius, cornerRadius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + cornerRadius, CGRectGetMaxY(rect) - cornerRadius, cornerRadius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) +cornerRadius, CGRectGetMinY(rect) + cornerRadius, cornerRadius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void) startActivityIndicator {
	[m_activityIndicator startAnimating];
}

- (void) stopActivityIndicator {
	[m_activityIndicator stopAnimating];
}

- (void) setStatusText: (NSString *) statusText {
	m_statusLabel.text = statusText;
}

- (void) dealloc {
	[m_activityIndicator release];
	[m_statusLabel release];
	[super dealloc];
}

@end
