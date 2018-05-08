//
//  DemonViewController.m
//  ReaderUserPDFKit
//
//  Created by liu on 2018/4/27.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "DemonViewController.h"
#import <PDFKit/PDFKit.h>
#import "ReaderToolView.h"
#import "ReaderThumbnailGridVC.h"
#import <MessageUI/MessageUI.h>

#pragma mark - Constants

#define kSTATUS_HEIGHT 20.0f
#define kTOOLBAR_HEIGHT 44.0f

//取得屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DemonViewController ()<PDFViewDelegate,ReaderToolViewDelegate,PDFDocumentDelegate,ReaderThumbnailGridVCDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) ReaderToolView *toolView;  //toolView 可查看预览、打印等

@property(nonatomic,strong) PDFView *pdfView; //展示pdf

@property(nonatomic,strong) PDFDocument *pdfDocument; //pdf 文档

@property(nonatomic,strong) PDFThumbnailView *thumbnailView; //展示pdf thumbnail

//@property(nonatomic,strong) UIPrintInteractionController *printInteraction;/**<打印功能*/

@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionVC;/**<分享功能*/

@end

@implementation DemonViewController

#pragma mark - LifeCycles
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    NSURL *url= [[NSBundle mainBundle] URLForResource:@"Reader" withExtension:@"pdf"];
    self.pdfDocument = [[PDFDocument alloc] initWithURL:url];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.thumbnailView];
    [self.view addSubview:self.pdfView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
#pragma mark - Action


#pragma mark - Delegate
//点击了thumnail
- (void)ReaderToolViewDelegateThumbnailClick {
    
    ReaderThumbnailGridVC *nailVC = [[ReaderThumbnailGridVC alloc] init];
    nailVC.pdfDocument = self.pdfDocument;
    nailVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nailVC];
    
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
- (void)ReaderToolViewDelegateShareClick {
    
//    if (self.printInteraction != nil) [self.printInteraction dismissAnimated:YES];
    // documentURL
    NSURL *fileURL = self.pdfDocument.documentURL;
    
    self.documentInteractionVC = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    
    self.documentInteractionVC.delegate = self;
    
    [self.documentInteractionVC presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)ReaderToolViewDelegatePrintClick {
    //见Reader框架实现
    
//    if ([UIPrintInteractionController isPrintingAvailable] == YES) {
//        NSURL *fileURL = self.pdfDocument.documentURL; // Document file URL
//
//        if ([UIPrintInteractionController canPrintURL:fileURL] == YES)
//        {
//            self.printInteraction = [UIPrintInteractionController sharedPrintController];
//
//            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
//            printInfo.duplex = UIPrintInfoDuplexLongEdge;
//            printInfo.outputType = UIPrintInfoOutputGeneral;
//            printInfo.jobName = @"哈哈";
//
//            self.printInteraction.printInfo = printInfo;
//            self.printInteraction.printingItem = fileURL;
//            [self.printInteraction presentAnimated:YES completionHandler:
//             ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
//             {
//#ifdef DEBUG
//                 if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
//#endif
//             }];
//        }
//    }
}

- (void)ReaderToolViewDelegateEmailClick {
   //    if (self.printInteraction != nil) [self.printInteraction dismissAnimated:YES];
    if ([MFMailComposeViewController canSendMail] == NO) return;
    NSFileManager *fileManager = [NSFileManager defaultManager]; // Singleton
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.pdfDocument.string error:NULL];
    unsigned long long fileSize = [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
    
    if (fileSize < 15728640ull) // Check attachment size limit (15MB)
    {
        NSURL *fileURL = self.pdfDocument.documentURL; NSString *fileName = self.pdfDocument.string;
        
        NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        
        if (attachment != nil) // Ensure that we have valid document file attachment data available
        {
            MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
            
            [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
            
            [mailComposer setSubject:fileName]; // Use the document file name for the subject
            
            mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            
            mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate
            
            [self presentViewController:mailComposer animated:YES completion:NULL];
        }
    }
}

/**
 写下实现思路 当想查的string变化时，也可是在searchBar的textDidChange处实现
 1.设置pdfDocument的代理，在初始化pdfDocument处设置 2.取消正在查找的内容
 3.beginFindString,实现该方法查找，即会在代理方法处didMatchString返回结果
 
 也可以通过第二种方式直接得到结果
 */
- (void)ReaderToolViewDelegateSearchClick {
    
#if 0
    self.pdfDocument.delegate = self;
    [self.pdfDocument cancelFindString];
    [self.pdfDocument findString:@"1" withOptions:NSWidthInsensitiveSearch];
#endif
    
    NSArray<PDFSelection *>  *array = [self.pdfDocument findString:@"1" withOptions:NSWidthInsensitiveSearch];
    for (PDFSelection *selection in array) {
        NSLog(@"selection = %@",selection.string);
    }
}
- (void)ReaderThumbnailGridVCDelegateVC:(ReaderThumbnailGridVC *)VC DidSelectPage:(PDFPage *)selectPage {
    
    [self.pdfView goToPage:selectPage];
}
//当点击了目录信息
- (void)ReaderThumbnailGridVCDelegateVC:(ReaderThumbnailGridVC *)VC DidSelectDirectory:(PDFOutline *)pdfOutLine {
    PDFAction *action = pdfOutLine.action;
    [self.pdfView performAction:action];
}
#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    
    self.documentInteractionVC = nil;
}

#pragma mark - MFMailComposeViewControllerDelegate methods
//邮件发送完成回调
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - PDFDocumentDelegate
//当调用beginFindString
- (void)didMatchString:(PDFSelection *)instance {
    
    PDFPage *page = instance.pages.firstObject;
    PDFOutline *outLine = [self.pdfDocument outlineItemForSelection:instance];
    NSLog(@"%@ page = %@",outLine.label,page.label);
}
//- (void)documentDidFindMatch:(NSNotification *)notification {
//    NSLog(@"找到啦 = %@",notification);
//}
//- (void)documentDidBeginDocumentFind:(NSNotification *)notification {
//    NSLog(@"开始查找");
//}

//- (void)documentDidEndPageFind:(NSNotification *)notification {
//
//    NSLog(@"%@",notification);
//}

#pragma mark - Setter && Getter
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

- (ReaderToolView *)toolView {
    
    if (!_toolView) {
        _toolView = [[ReaderToolView alloc] initWithFrame:CGRectMake(0, kSTATUS_HEIGHT, kScreenWidth, kTOOLBAR_HEIGHT)];
        _toolView.delegate = self;
    }
    return _toolView;
}

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

@end

