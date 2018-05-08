//
//  ReaderThumbnailGridVC.m
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/30.
//  Copyright © 2018年 liu. All rights reserved.
//  没实现书签功能，书签功能可根据Reader实现

#import "ReaderThumbnailGridVC.h"
#import "ReaderThumbnailCell.h"
#import "ReaderThumbnailToolView.h"
//取得屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kSTATUS_HEIGHT 20.0f
#define kTOOLBAR_HEIGHT 44.0f
#define kPADDING 10.0f

@interface ReaderThumbnailGridVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,ReaderThumbnailToolViewDelegate>

@property(nonatomic,strong) ReaderThumbnailToolView *toolView;
@property(nonatomic,strong) UICollectionView *collectionView; //展示预览和标签
@property(nonatomic,strong) UITableView *tableView;  //展示目录，前题是该pdf文档建有目录
@property(nonatomic,strong) NSMutableArray<PDFOutline *> *dirArray; // 目录文件

@end

@implementation ReaderThumbnailGridVC

static NSString * const reuseIdentifier = @"kReaderThumbnailCellIdentify";
static NSString * const cellReuseIdentifier = @"kCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.selectType = SegmentSelectThumbnail;
    
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    for (UIView *subViews in self.navigationController.navigationBar.subviews) {
        [subViews removeFromSuperview];
    }
    [self.navigationController.navigationBar addSubview:self.toolView];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if (self.selectType == SegmentSelectThumbnail || self.selectType == SegmentSelectBookMarket) return 1;
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.selectType == SegmentSelectThumbnail) return self.pdfDocument.pageCount;
    if (self.selectType == SegmentSelectBookMarket) return self.pdfDocument.selectionForEntireDocument.pages.count;  //暂未实现书签，可根据Reader框架加个数组实现，现暂用这个代替
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ReaderThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PDFPage *pdfPage = self.selectType == SegmentSelectThumbnail ? [self.pdfDocument pageAtIndex:indexPath.item] : self.pdfDocument.selectionForEntireDocument.pages[indexPath.item];
    
    UIImage *pdfImage = [pdfPage thumbnailOfSize:cell.bounds.size forBox:kPDFDisplayBoxCropBox];
    cell.image = pdfImage;
    cell.pageText = pdfPage.label;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectType == SegmentSelectThumbnail || self.selectType == SegmentSelectBookMarket) {
        PDFPage *pdfPage = self.selectType == SegmentSelectThumbnail ? [self.pdfDocument pageAtIndex:indexPath.item] : self.pdfDocument.selectionForEntireDocument.pages[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(ReaderThumbnailGridVCDelegateVC:DidSelectPage:)]) {
            [self.delegate ReaderThumbnailGridVCDelegateVC:self DidSelectPage:pdfPage];
        }
    }else {
        PDFOutline *outLine = self.dirArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(ReaderThumbnailGridVCDelegateVC:DidSelectPage:)]) {
            [self.delegate ReaderThumbnailGridVCDelegateVC:self DidSelectDirectory:outLine];
        }
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFOutline *outline = self.dirArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    cell.textLabel.text = outline.label;
    cell.detailTextLabel.text = outline.destination.page.label;
    return cell;
}

#pragma mark - <UITableViewDelegate && DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.selectType == SegmentSelectDirectory) return 1;
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectType == SegmentSelectDirectory) return self.dirArray.count;
    return 0;
    
}

#pragma mark - ToolViewDelegate
- (void)ReaderThumbnailToolViewDelegateDidSelectIndex:(SegmentSelect)index {
    
    if (index == self.selectType) return;
    self.selectType = index;
    [self refreshViewLayout];
}

- (void)ReaderThumbnailToolViewDelegateDidSelectReading {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Provate Method
- (void)refreshViewLayout {
    
    if (self.selectType == SegmentSelectDirectory) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        [self.tableView reloadData];
    } else {
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
        [self.collectionView reloadData];
    }
}
#pragma mark - Setter && Getter
- (ReaderThumbnailToolView *)toolView {
    
    if (!_toolView) {
        _toolView = [[ReaderThumbnailToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTOOLBAR_HEIGHT)];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.delegate = self;
    }
    return _toolView;
}


- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = kPADDING;
        flowLayout.minimumInteritemSpacing = kPADDING;
        CGFloat width = (self.view.frame.size.width - kPADDING*4)/3;
        CGFloat height = width * 1.5;
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = FALSE;
        [_collectionView registerClass:[ReaderThumbnailCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.hidden = YES;
        _tableView.rowHeight = 44.0f;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _tableView;
}

- (NSMutableArray<PDFOutline *> *)dirArray {
    
    if (!_dirArray) {
        _dirArray = [NSMutableArray array];
        for (NSInteger index = 0; index < self.pdfDocument.outlineRoot.numberOfChildren; index++) {
            PDFOutline *outLine = [self.pdfDocument.outlineRoot childAtIndex:index];
            [_dirArray addObject:outLine];
        }
    }
    return _dirArray;
}
@end
