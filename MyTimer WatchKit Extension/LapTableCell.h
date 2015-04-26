
#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface LapTableCell : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *numberLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;

@end
