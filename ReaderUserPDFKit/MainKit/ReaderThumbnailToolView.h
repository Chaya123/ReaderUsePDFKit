//
//  ReaderThumbnailToolView.h
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    SegmentSelectThumbnail = 0, //预览pdf文档
    SegmentSelectDirectory,     //目录
    SegmentSelectBookMarket     //书签
    
}SegmentSelect;

@protocol ReaderThumbnailToolViewDelegate <NSObject>

@optional
//选中哪个功能
- (void)ReaderThumbnailToolViewDelegateDidSelectIndex:(SegmentSelect)index;
//续读
- (void)ReaderThumbnailToolViewDelegateDidSelectReading;

@end


@interface ReaderThumbnailToolView : UIView

@property(nonatomic,weak) id<ReaderThumbnailToolViewDelegate>  delegate;

@end
