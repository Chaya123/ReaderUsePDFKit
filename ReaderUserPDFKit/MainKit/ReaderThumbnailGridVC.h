//
//  ReaderThumbnailGridVC.h
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
#import "ReaderThumbnailToolView.h"

@class ReaderThumbnailGridVC;
@protocol ReaderThumbnailGridVCDelegate <NSObject>
@optional
//选中了第几页
- (void)ReaderThumbnailGridVCDelegateVC:(ReaderThumbnailGridVC *)VC DidSelectPage:(PDFPage *)selectPage;
//点击某个目录
- (void)ReaderThumbnailGridVCDelegateVC:(ReaderThumbnailGridVC *)VC DidSelectDirectory:(PDFOutline *)pdfOutLine;

@end

@interface ReaderThumbnailGridVC : UIViewController

@property(nonatomic,weak) id<ReaderThumbnailGridVCDelegate>  delegate;

@property(nonatomic,strong) PDFDocument *pdfDocument;
//类型
@property(nonatomic,assign) SegmentSelect  selectType;

@end
