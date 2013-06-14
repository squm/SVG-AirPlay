//
//  SecondWindow.m
//  SVG AirPlay
//

#import "SecondWindow.h"
#import "SVGKFastImageView.h"
#import "NodeList+Mutable.h"

@interface SecondWindow () {
	BOOL isInitialized;

	// connection observers exist
	BOOL isNotified;

	// connection exist
	BOOL isHere;

	UIWindow *externalWindow;
	SVGKFastImageView *imageViewSvg;
}

@end

@implementation SecondWindow

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

+ (SecondWindow *) sharedInstance
{
	static dispatch_once_t _singletonPredicate;
	static SecondWindow *_singleton = nil;

	dispatch_once(&_singletonPredicate, ^{
		_singleton = [[super allocWithZone:nil] init];
	});

	return _singleton;
}

+ (id) allocWithZone:(NSZone *)zone
{
	return [self sharedInstance];
}

- (id) init
{
	if (self = [super init]) {
		NSLog(@"second super init");
		isHere = NO;
		isInitialized = NO;
		isNotified = NO;
		[self secondNotifySetup];
	}

	return self;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void) secondInitWithScreen: (UIScreen *) newScreen
{
	if (externalWindow || isInitialized) {
		NSLog(@"second init error: already initialized");
		return;
	}

	isInitialized = YES;
	isHere = YES;

	// Get the screen's bounds so that you can create a window of the correct size.
	CGRect screenBounds = newScreen.bounds;

	NSLog(@"second successful init: %@", NSStringFromCGRect(screenBounds));

	externalWindow = [[UIWindow alloc] initWithFrame:screenBounds];
	externalWindow.screen = newScreen;
	externalWindow.hidden = NO;

	externalWindow.rootViewController = self;
}

- (void) secondInit
{
	// manual initialization

	if ([[UIScreen screens] count] <= 1) {
		NSLog(@"second mirroring is not available");
		return;
	}

	// Get the screen object that represents the external display.
	UIScreen *newScreen = [UIScreen screens][1];
	[self secondInitWithScreen:newScreen];
}

- (void) handleScreenDidConnectNotification:(NSNotification*)aNotification
{
	// automatic initialization

	NSLog(@"second connect");

	UIScreen *newScreen = [aNotification object];
	[self secondInitWithScreen: newScreen];
}

- (void) secondRelease
{
	NSLog(@"second disconnect");

	isInitialized = NO;
	isHere = NO;

	if (externalWindow) {
		// Hide and then delete the window.
		externalWindow.hidden = YES;
		externalWindow = nil;
	}
}

- (void) secondNotifySetup
{
	// connection of screens

	if (isNotified) {
		return;
	}

	isNotified = YES;

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

	[center addObserver:self
		   selector:@selector(handleScreenDidConnectNotification:)
		       name:UIScreenDidConnectNotification object:nil];

	[center addObserver:self
		   selector:@selector(secondRelease)
		       name:UIScreenDidDisconnectNotification
		     object:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.frame = externalWindow.frame;

	self.view.backgroundColor = [UIColor darkGrayColor];

	SVGKImage *imageSvg = [SVGKImage imageNamed:@"svg_logo.svg"];

	imageViewSvg = [[SVGKFastImageView alloc] initWithSVGKImage:imageSvg];
	imageViewSvg.frame = self.view.frame;
//	imageViewSvg.clipsToBounds = YES;
//	imageViewSvg.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:imageViewSvg];
}

- (void) secondDownload: (NSString *) urlString
{
	if (urlString == nil || [urlString isEqualToString:@""]) {
		urlString = @"http://upload.wikimedia.org/wikipedia/commons/d/d0/Pittsburgh_city_coat_of_arms.svg";
	}
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSData *urlData = [NSData dataWithContentsOfURL:url];
	if (urlData) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];

		NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.svg"];
		[urlData writeToFile:filePath atomically:YES];

		SVGKImage *document = nil;
		document = [SVGKImage imageWithContentsOfFile:filePath];

		if (document == nil)
		{
			[[[[UIAlertView alloc] initWithTitle:@"SVG parse failed" message:@"Total failure. See console log" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}

		imageViewSvg.image = document;
	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"URL error" message:@"data object from the location specified by a given URL could not be created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		
	}

}

@end