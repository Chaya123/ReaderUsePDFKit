//
//  ReaderThumbnailToolView.m
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ReaderThumbnailToolView.h"

@interface ReaderThumbnailToolView()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ReaderThumbnailToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ReaderThumbnailToolView" owner:self options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}


- (IBAction)segmentClick:(UISegmentedControl *)sender {
    
    SegmentSelect index = SegmentSelectThumbnail;
    switch (sender.selectedSegmentIndex) {
        case 0:
            index = SegmentSelectThumbnail;
            break;
        case 1:
            index = SegmentSelectDirectory;
            break;
        case 2:
            index = SegmentSelectBookMarket;
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(ReaderThumbnailToolViewDelegateDidSelectIndex:)]) {
        [self.delegate ReaderThumbnailToolViewDelegateDidSelectIndex:index];
    }
}


- (IBAction)readingButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ReaderThumbnailToolViewDelegateDidSelectReading)]) {
        [self.delegate ReaderThumbnailToolViewDelegateDidSelectReading];
    }
}


@end
