//
//  ReaderToolView.m
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/28.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ReaderToolView.h"

@interface ReaderToolView()

/**
 如不需要设置属性，则不需要
 */
@property (weak, nonatomic) IBOutlet UIButton *thumbnailButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *bookMarkButton;

@end

@implementation ReaderToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ReaderToolView" owner:self options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}




- (IBAction)thumbnailClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegateThumbnailClick)]) {
        [self.delegate ReaderToolViewDelegateThumbnailClick];
    }
}
- (IBAction)shareClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegateShareClick)]) {
        [self.delegate ReaderToolViewDelegateShareClick];
    }
}

- (IBAction)printClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegatePrintClick)]) {
        [self.delegate ReaderToolViewDelegatePrintClick];
    }
}

- (IBAction)emailClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegateEmailClick)]) {
        [self.delegate ReaderToolViewDelegateEmailClick];
    }
}

- (IBAction)searchClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegateSearchClick)]) {
        [self.delegate ReaderToolViewDelegateSearchClick];
    }
}
- (IBAction)bookMarkClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderToolViewDelegateBookMarkClick)]) {
        [self.delegate ReaderToolViewDelegateBookMarkClick];
    }
}



@end
