//
// SFHFActivityIndicatingCell.m
//
// Created by Buzz Andersen on 12/3/08.
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

#import "SFHFActivityIndicatingCell.h"


@implementation SFHFActivityIndicatingCell

@synthesize activityIndicator = m_activityIndicator;
@synthesize isIndicatingActivity = m_isIndicatingActivity;
@synthesize textLabel = m_textLabel;
@synthesize imageView = m_imageView;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
		self.activityIndicator = activityIndicator;
		[activityIndicator release];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		self.textLabel = textLabel;
		self.textLabel.font = self.font;
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview: self.textLabel];
		[textLabel release];

		UIImageView *imageView = [[UIImageView alloc] initWithImage: nil];	
		self.imageView = imageView;
		[self addSubview: self.imageView];
		[imageView release];
				
		self.isIndicatingActivity = NO;
		
		[self layoutSubviews];

    }
    return self;
}

- (void) setImage: (UIImage *) theImage {
	super.image = theImage;
	self.imageView.image = theImage;
	[self layoutSubviews];
}

- (void) setText: (NSString *) theText {
	super.text = theText;
	
	self.textLabel.text = theText;
}

- (void) setFont: (UIFont *) theFont {
	super.font = theFont;
	
	self.textLabel.font = super.font;
}

- (void) layoutSubviews {
	CGFloat indentWidth = ((self.indentationLevel + 1) * self.indentationWidth) + 10;
	CGFloat verticalMidpoint = ceil(self.frame.size.height / 2);

	CGRect imageViewFrame = CGRectZero;
	
	if (self.image) {
		imageViewFrame = CGRectMake(indentWidth, verticalMidpoint - (self.image.size.height / 2), self.image.size.width, self.image.size.height);
		self.imageView.frame = imageViewFrame;
	}
	
	[self.textLabel sizeToFit];
	CGRect textLabelFrame = CGRectMake(imageViewFrame.origin.x + imageViewFrame.size.width + 10, verticalMidpoint - (self.textLabel.frame.size.height / 2), self.textLabel.frame.size.width, self.textLabel.frame.size.height);
	self.textLabel.frame = textLabelFrame;
	
	if (self.isIndicatingActivity) {
		CGRect activityIndicatorFrame = self.activityIndicator.frame;
		CGFloat imageViewMidpoint = imageViewFrame.origin.x + (imageViewFrame.size.width / 2);
		activityIndicatorFrame.origin.x = imageViewMidpoint - (activityIndicatorFrame.size.width / 2);
		activityIndicatorFrame.origin.y = verticalMidpoint - (activityIndicatorFrame.size.height / 2);
		
		self.activityIndicator.frame = activityIndicatorFrame;
	}
}

- (void) startIndicatingActivity {
	if (self.isIndicatingActivity) return;
	
	self.isIndicatingActivity = YES;
	
	[self layoutSubviews];
	
	[self addSubview: self.activityIndicator];
	[self.imageView removeFromSuperview];
	[self.activityIndicator startAnimating];
}

- (void) stopIndicatingActivity {
	if (!self.isIndicatingActivity) return;
	
	self.isIndicatingActivity = NO;
	
	[self layoutSubviews];
	
	[self addSubview: self.imageView];
	[self.activityIndicator removeFromSuperview];
	[self.activityIndicator stopAnimating];
}

- (void)dealloc {
	[m_activityIndicator release];
	[m_textLabel release];
	[m_imageView release];
	
    [super dealloc];
}

@end
