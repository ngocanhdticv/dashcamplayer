#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface PlayerView : NSObject <FlutterPlatformView>
@property(nonatomic, strong) VLCMediaPlayer *mediaPlayer;

// UI Components
@property(nonatomic, strong) UIView *rootView;
@property(nonatomic, strong) UIButton *playPauseButton;
@property(nonatomic, strong) UILabel *currentTimeLabel;
@property(nonatomic, strong) UILabel *totalTimeLabel;
@property(nonatomic, strong) UISlider *progressSlider;
@property(nonatomic, strong) UIView *controlOverlay;

// Initializer
- (instancetype _Nullable)initWithFrame:(CGRect)frame
                         viewIdentifier:(int64_t)viewId
                              arguments:(id _Nullable)args
                        binaryMessenger:(NSObject <FlutterBinaryMessenger> *_Nonnull)messenger;

// Public Methods
- (UIView *_Nonnull)view;

- (void)togglePlayPause;

- (void)updateProgress;
@end
