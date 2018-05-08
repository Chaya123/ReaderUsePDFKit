//
//  ReaderThumbnailCell.h
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderThumbnailCell : UICollectionViewCell

@property(nonatomic,copy) NSString *pageText; //第几页
@property(nonatomic,strong) UIImage *image;  //展示pdf图片

@end
