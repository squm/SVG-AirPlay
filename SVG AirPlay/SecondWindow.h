//
//  SecondWindow.h
//  SVG AirPlay
//

#import <UIKit/UIKit.h>

@interface SecondWindow : UIViewController

- (void) secondInit;
- (void) secondRelease;
- (void) secondNotifySetup;
- (void) secondDownload: (NSString *) urlString;

@end