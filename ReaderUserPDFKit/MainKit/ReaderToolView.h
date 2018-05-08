//
//  ReaderToolView.h
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/28.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderToolViewDelegate <NSObject>

@optional
/**预览整个文档*/
- (void)ReaderToolViewDelegateThumbnailClick;
/**分享整个文档*/
- (void)ReaderToolViewDelegateShareClick;
/**打印文档*/
- (void)ReaderToolViewDelegatePrintClick;
/**发邮件*/
- (void)ReaderToolViewDelegateEmailClick;
/**查询文档*/
- (void)ReaderToolViewDelegateSearchClick;
/**点击书签*/
- (void)ReaderToolViewDelegateBookMarkClick;

@end

@interface ReaderToolView : UIView

@property(nonatomic,weak) id<ReaderToolViewDelegate> delegate;

@end
