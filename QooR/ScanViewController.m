//
//  ScanViewController.m
//  QooR
//
//  Created by Steve Spencer on 3/29/13.
//  Copyright (c) 2013 Steve Spencer. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()
@property (nonatomic) BOOL blockScan;
@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"HELLO WORLD");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Turn off all symbols first.  Then enable them explicitly.
    // http://zbar.sourceforge.net/iphone/sdkdoc/optimizing.html
    [self.scanner setSymbology: 0            config: ZBAR_CFG_ENABLE to: 0];
    [self.scanner setSymbology: ZBAR_UPCA    config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_UPCE    config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_EAN2    config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_EAN5    config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_EAN8    config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_EAN13   config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_ISBN10  config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_ISBN13  config: ZBAR_CFG_ENABLE to: 1];
    [self.scanner setSymbology: ZBAR_QRCODE  config: ZBAR_CFG_ENABLE to: 1];

    self.readerDelegate            = self;
    self.supportedOrientationsMask = ZBarOrientationMaskAll;
    self.showsZBarControls         = NO;  // Hide ZBar toolbar (Close / Help)
    self.tracksSymbols             = YES;//NO;  // Show greenbox for UPC??
    self.readerView.torchMode      = NO;  // No flash
    self.wantsFullScreenLayout     = YES;  // Stops ZBar from messing with StatusBar
    self.readerView.zoom           = 1.0; // Don't zoom camera (default is 1.25)


	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.blockScan = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Scanner
- (void)imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    if (self.blockScan) return;

    // process first result (are there ever more??)
    for(ZBarSymbol *symbol in info[ZBarReaderControllerResults]) {

        // Only place where scan is blocked
        if (symbol.type == ZBAR_NONE || symbol.type == ZBAR_PARTIAL) {
            continue;
        }

        self.blockScan = YES;
        [self processScannedSymbol:symbol];
        break;
    }
}

- (void)processScannedSymbol:(ZBarSymbol *)symbol
{
    if (symbol.type == ZBAR_QRCODE) {
        NSLog(@"QRCode: %@", symbol.data);
    } else {
        // probably barcoe
        NSLog(@"Bar Code: %@", symbol.data);
    }

    // normally wouldn't do this hear (to prevent double scans)
    self.blockScan = NO;
}

@end
