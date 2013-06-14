//
//  ViewController.h
//  SVG AirPlay
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *textUrl;
}
- (IBAction)clickGo:(id)sender;

@end
