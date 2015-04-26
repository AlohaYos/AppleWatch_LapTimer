
#import "InterfaceController.h"
#import "LapTableCell.h"

@interface InterfaceController() {
	
	NSTimeInterval	startTime;	// 開始時刻のメモ
	NSTimer*		timer;		// タイマーオブジェクト
	NSMutableArray* lapArray;	// ラップタイムを保持する配列
}

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

	// ラップタイムを保持する配列を初期化
	lapArray = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)willActivate {
    [super willActivate];

	// タイマー停止状態のボタン表示
	[self setButtonPhase:timerStopped];
	
	// リセットで初期化
	[self resetButtonPushed];
}

- (void)didDeactivate {

	// Watchフェイスから画面が消えたらタイマーを止める
	[self stopButtonPushed];

	[super didDeactivate];
}

#pragma mark - Button job

// Startボタンが押された時の処理
- (IBAction)startButtonPushed {
	
	// タイマーを起動
	if(!timer) {
		timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerJob) userInfo:nil repeats:YES];
	}
	
	// ラベルの初期表示
	[_timerLabel setText:@"00:00:00"];
	
	// 開始時刻をメモする
	startTime = [NSDate timeIntervalSinceReferenceDate];

	// タイマー稼働状態のボタン表示
	[self setButtonPhase:timerRunning];
}

// Stopボタンが押された時の処理
- (IBAction)stopButtonPushed {

	// タイマー停止状態のボタン表示
	[self setButtonPhase:timerStopped];

	// タイマーを廃棄
	[timer invalidate];
	timer = nil;
}

// Lapボタンが押された時の処理
- (IBAction)lapButtonPushed {
	
	// 表示時刻を配列に加える
	NSString* timeStr = [self getTimeString];
	[lapArray addObject:timeStr];

	// テーブルの再表示
	[self loadTableData];
}

// Resetボタンが押された時の処理
- (IBAction)resetButtonPushed {

	// 時刻表示をクリア
	[_timerLabel setText:@"00:00:00"];
	
	// ラップタイムの配列をクリア
	[lapArray removeAllObjects];
	
	// テーブルの再表示
	[self loadTableData];
}

- (void)setButtonPhase:(int)timerPhase {
	
	// ボタンを隠すことで表示スペースを詰める
	switch (timerPhase) {
		case timerStopped:	// タイマー停止時
			[_startButton setHidden:NO];
			[_resetButton setHidden:NO];
			[_stopButton setHidden:YES];
			[_lapButton setHidden:YES];
			break;
		case timerRunning:	// タイマー稼働時
			[_startButton setHidden:YES];
			[_resetButton setHidden:YES];
			[_stopButton setHidden:NO];
			[_lapButton setHidden:NO];
			break;
	}
}

#pragma mark - Timer job

// 定期タイマー処理
- (void)timerJob {
	
	// 経過時間をラベルに表示
	[_timerLabel setText:[self getTimeString]];
}

- (NSString*)getTimeString {
	
	// メモした開始時刻からの差分を計算
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate] - startTime;
	
	// 経過時間を文字列に
	int hour = interval / (60*60);
	int min  = fmod((interval/60), 60);
	int sec  = fmod(interval, 60);
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
}

#pragma mark - Table job

// lapArrayの内容をテーブルに表示する
- (void)loadTableData {
	
	// テーブルにlapArray.count行のLapTableCellインスタンスをぶら下げる
	[_lapTable setNumberOfRows:lapArray.count withRowType:@"LapTableCell"];
	
	// 各行のLapTableCellインスタンスに表示データを設定する
	for(int i=0; i < lapArray.count; i++) {
		
		// 時系列の逆順（新しい順）に表示するためにインデックスを逆算
		long index = lapArray.count-i-1;
		
		// i行目のLapTableCellインスタンスを取得
		LapTableCell* row = [_lapTable rowControllerAtIndex:i];
		
		// ラベルに表示するデータを設定
		[row.numberLabel setText:[NSString stringWithFormat:@"%ld", index+1]];
		[row.timeLabel setText:[lapArray objectAtIndex:index]];
	}
}

@end

