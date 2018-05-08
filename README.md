ReaderUsePDFKit
#### 三、PDFKit的简单使用

PDFKit相关类

PDFKit的相关类不多，简单易用，实质就是对Quartz的C语言的一个封装，刚刚看了Reader源码，对其就更好了解了。相关类如下：

1､PDFDocument: 代表一个PDF文档，可以使用初始化方法-initWithURL；包含了文档一些基本属性、如pageCount(页面数)，是否锁定、加密，可否打印、复制，提供增删查改某页、查找内容等功能。如果需要文档修改时间、大小、书签可以借鉴Reader对其封装。
```
self.pdfDocument = [[PDFDocument alloc] initWithURL:url];
```

2､PDFView: 呈现PDF文档的UIView，包括一些文档操作（如链接跳转、页面跳转、选中），可使用-initWithDocument:方法进行初始化，也可用-initWithFrame:;可以设置其展示样式。
```
- (PDFView *)pdfView {

if (!_pdfView) {
_pdfView = [[PDFView alloc] initWithFrame:CGRectMake(0, kTOOLBAR_HEIGHT + kSTATUS_HEIGHT, kScreenWidth, kScreenHeight - kTOOLBAR_HEIGHT - kSTATUS_HEIGHT - 60)];
_pdfView.autoScales = YES;   //自动适应尺寸
//        _pdfView.displayMode = kPDFDisplaySinglePageContinuous;  // 默认是这个模式
_pdfView.displayDirection = kPDFDisplayDirectionHorizontal;

_pdfView.delegate = self;
//        _pdfView.interpolationQuality = kPDFInterpolationQualityHigh;
//        _pdfView.displaysAsBook = YES;
_pdfView.document = self.pdfDocument;
[_pdfView usePageViewController:YES withViewOptions:nil];
}
return _pdfView;
}
```

3､ PDFThumbnailView: 这个类是一个关于PDF的缩略视图。通过设置其PDFView属性来关联一个PDFView
```
- (PDFThumbnailView *)thumbnailView {

if (!_thumbnailView) {
_thumbnailView = [[PDFThumbnailView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 45, kScreenWidth, 45)];
_thumbnailView.thumbnailSize = CGSizeMake(20, 25); //设置size
_thumbnailView.backgroundColor = [UIColor whiteColor];
_thumbnailView.PDFView = self.pdfView;
_thumbnailView.layoutMode = PDFThumbnailLayoutModeHorizontal;
}
return _thumbnailView;
}
```

4､ PDFPage: 表示了当前PDF文档中的一页，有label属性来代表是第几页、rotation（旋转角度）、NSArray< PDFAnnotation *>本页中的一些备注信息等；
```
PDFPage *pdfPage = [self.pdfDocument pageAtIndex:indexPath.item] ;
UIImage *pdfImage = [pdfPage thumbnailOfSize:cell.bounds.size forBox:kPDFDisplayBoxCropBox];
```

5､ PDFOutline: 表示了整个PDF文档的轮廓，比如有些带目录标签的文档
```
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
```
6､ PDFAnnotation: 表示了PDF文档中加入的一些标注，如下划线，删除线，备注等等。
```
//可以自定义UIMenuController中的UIMenuItem来实现笔记功能

PDFAnnotation *annotation = [[PDFAnnotation alloc] initWithBounds:CGRectMake(100, 100, 100, 10) forType:PDFAnnotationSubtypeCircle withProperties:@{PDFAnnotationKeyColor:[UIColor redColor]}];
annotation.shouldDisplay = YES;
[self.pdfView.currentPage addAnnotation:annotation];
```

7､ PDFSelection：表示了PDF文档中的一个选区，string属性代表选区内容
```
NSArray<PDFSelection *>  *array = [self.pdfDocument findString:@"12" withOptions:NSWidthInsensitiveSearch];
for (PDFSelection *selection in array) {
NSLog(@"selection = %@",selection.string);
}
```

8､ PDFAction: 表示了PDF文档中的一个动作，比如点击一个链接等等
```
//当点击了目录信息
- (void)ReaderThumbnailGridVCDelegateVC:(ReaderThumbnailGridVC *)VC DidSelectDirectory:(PDFOutline *)pdfOutLine {
PDFAction *action = pdfOutLine.action; //也可用PDFDestination实现
[self.pdfView performAction:action];
}
```
9、PDFKitPlatformView：宏定义

效果图如下

![image](https://github.com/Chaya123/ReaderUsePDFKit/blob/master/ReaderUserPDFKit/Resource/1.jpeg)
![image](https://github.com/Chaya123/ReaderUsePDFKit/blob/master/ReaderUserPDFKit/Resource/2.jpeg)
