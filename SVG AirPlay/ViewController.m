//
//  ViewController.m
//  SVG AirPlay
//

#import "ViewController.h"
#import "SecondWindow.h"

@interface ViewController () {
	SecondWindow *secondWindow;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	secondWindow = [[SecondWindow alloc] init];
	[secondWindow secondNotifySetup];
	[secondWindow secondInit];

	textUrl.delegate = self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[self clickGo:nil];
	[secondWindow secondDownload:textField.text];
	return YES;
}

- (IBAction)clickGo:(id)sender {
	[secondWindow secondDownload: textUrl.text];
}

- (void)dealloc {
	[textUrl release];
	[super dealloc];
}
@end
