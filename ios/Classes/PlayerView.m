#import "PlayerView.h"

@implementation PlayerView {
    UIView *_view;
    UIButton *_playButton;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
    UISlider *_seekBar;
    NSTimer *_progressUpdater;
    VLCMediaPlayer *_mediaPlayer;
}
- (instancetype _Nullable )initWithFrame:(CGRect)frame
                          viewIdentifier:(int64_t)viewId
                               arguments:(id _Nullable)args
                         binaryMessenger:(NSObject <FlutterBinaryMessenger> *_Nonnull)messenger
                         withMediaPlayer:(VLCMediaPlayer *)mediaPlayer {
    if (self) {
        _mediaPlayer = mediaPlayer;

        // Main view setup
        _view = [[UIView alloc] initWithFrame:frame];
        _view.backgroundColor = [UIColor blackColor];
        mediaPlayer.drawable = _view;

        // Video URL setup
        NSString *videoURL = args[@"videoURL"];
        NSNumber *isLocalFile = args[@"isLocalFile"];
        BOOL isLocal = [isLocalFile boolValue];
        VLCMedia *media;
        if (isLocal) {
            media = [VLCMedia mediaWithPath:videoURL];
        } else {
            media = [VLCMedia mediaWithURL:[NSURL URLWithString:videoURL]];
        }
        mediaPlayer.media = media;
        [mediaPlayer play];

        // Play button setup
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(20, frame.size.height - 80, 40, 40);
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(togglePlayPause) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:_playButton];

        // Time labels setup
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, frame.size.height - 80,
                                                                      80, 40)];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.text = @"00:00";
        [_view addSubview:_currentTimeLabel];

        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 100,
                                                                    frame.size.height - 80, 80,
                                                                    40)];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentRight;
        _totalTimeLabel.text = @"00:00";
        [_view addSubview:_totalTimeLabel];

        // Seek bar setup
        _seekBar = [[UISlider alloc] initWithFrame:CGRectMake(20, frame.size.height - 40,
                                                              frame.size.width - 40, 20)];
        [_seekBar addTarget:self action:@selector(seekBarValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_view addSubview:_seekBar];

        // Start progress updater
        _progressUpdater = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return self;
}

- (UIView *)view {
    return _view;
}

- (void)togglePlayPause {
    if (_mediaPlayer.isPlaying) {
        [_mediaPlayer pause];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [_mediaPlayer play];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)updateProgress {
    if (_mediaPlayer.media.length.intValue > 0) {
        int currentTime = _mediaPlayer.time.intValue / 1000;
        int totalTime = _mediaPlayer.media.length.intValue / 1000;

        _currentTimeLabel.text = [self formatTime:currentTime];
        _totalTimeLabel.text = [self formatTime:totalTime];
        _seekBar.value = (float) currentTime / totalTime;
    }
}

- (void)seekBarValueChanged:(UISlider *)slider {
    int totalTime = _mediaPlayer.media.length.intValue / 1000;
    int seekTime = slider.value * totalTime * 1000; // Convert to milliseconds
    [_mediaPlayer setTime:[VLCTime timeWithInt:seekTime]];
}

- (NSString *)formatTime:(int)timeInSeconds {
    int minutes = timeInSeconds / 60;
    int seconds = timeInSeconds % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
