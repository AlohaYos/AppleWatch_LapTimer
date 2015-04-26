
#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

// タイマーの状態
enum {
	timerStopped = 0,
	timerRunning
} timerPhase;


@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *timerLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *lapTable;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *startButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *stopButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *lapButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *resetButton;

@end
