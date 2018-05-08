//
//  ReaderThumbnailCell.m
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ReaderThumbnailCell.h"

@interface ReaderThumbnailCell()
/**展示图片*/
@property(nonatomic,strong) UIImageView *pdfView;

@property(nonatomic,strong) UILabel *pageLabel;

@end

@implementation ReaderThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addView];
    }
    return self;
}

- (void)addView {
    
    [self addSubview:self.pdfView];
    [self addSubview:self.pageLabel];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.pdfView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.pageLabel.frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height - 30, 90, 40);
}

#pragma mark - Setter && Getter

- (void)setImage:(UIImage *)image {
    _image = image;
    self.pdfView.image = image;
}

- (void)setPageText:(NSString *)pageText {
    _pageText = pageText;
    self.pageLabel.text = pageText;
}
- (UIImageView *)pdfView {
    
    if (!_pdfView) {
        _pdfView = [[UIImageView alloc] init];
    }
    return _pdfView;
}
- (UILabel *)pageLabel {
    
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.font = [UIFont boldSystemFontOfSize:13];
        _pageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _pageLabel;
}
@end
