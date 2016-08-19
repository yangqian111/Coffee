//
//  CFAddCoffeeViewControllerDescVideoCell.m
//  Coffee
//
//  Created by yangqian on 16/8/17.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerDescVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CFAddCoffeeViewControllerDescVideoCell ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) UIButton *button;

@end

@implementation CFAddCoffeeViewControllerDescVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        _moviePlayer.scalingMode = MPMovieScalingModeFill;
        _moviePlayer.shouldAutoplay = NO;
        [self.contentView addSubview: _moviePlayer.view];
        [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(300);
            make.bottom.mas_equalTo(self.contentView);
        }];
        
        _button = [UIButton new];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(playMyVideo) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(100);
        }];
        
        [self addNotification];
    }
    return self;
}

-(void)configCell:(NSURL *)videoURL {
    _videoURL = videoURL;
    _moviePlayer.contentURL = _videoURL;
    [self thumbnailImageRequest];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification {
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerThumbnailRequestFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
}

/**
 *  缩略图请求完成,此方法每次截图成功都会调用一次
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerThumbnailRequestFinished:(NSNotification *)notification {
    NSLog(@"视频截图完成.");
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];
    //保存图片到相册(首次调用会请求用户获得访问相册权限)
    UIImageView *videoImage = [[UIImageView alloc] initWithFrame:self.moviePlayer.view.frame];
    videoImage.image = image;
    [self.moviePlayer.view addSubview:videoImage];
}

/**
 *  获取视频缩略图
 */
-(void)thumbnailImageRequest {
    //获取视频开始的缩略图
    [self.moviePlayer requestThumbnailImagesAtTimes:@[@0.0,@0.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)playMyVideo {
    [_moviePlayer setFullscreen:YES];
    [_moviePlayer play];
}

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            [_moviePlayer setFullscreen:NO];
            break;
        default:
            break;
    }
}

@end
