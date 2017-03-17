//
//  CFCoffeeDetailTableViewCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/9.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFCoffeeDetailTableViewCell.h"
#import "TYAttributedLabel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CFCoffeeDetailTableViewCell ()

@property (nonatomic,weak) UIImageView *avatar;
@property (nonatomic,weak) UILabel *name;
@property (nonatomic,weak) UILabel *price;

@property (nonatomic,weak) UITextView *properties;
@property (nonatomic,weak) TYAttributedLabel *descLabel;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,weak) UIImageView *thumbnailImageView;

@end

@implementation CFCoffeeDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *icon = [UIImageView new];
        [self.contentView addSubview:icon];
        icon.image = [UIImage imageNamed:@"icon"];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).mas_offset(40);
            make.width.mas_equalTo(240);
            make.height.mas_equalTo(125);
        }];
        
        UIImageView *addAvatar = [UIImageView new];
        addAvatar.backgroundColor = [UIColor whiteColor];
        addAvatar.image =[UIImage imageNamed:@"default_coffee"];
        addAvatar.layer.cornerRadius = 65;
        addAvatar.layer.masksToBounds = YES;
        self.avatar = addAvatar;
        [self.contentView addSubview:addAvatar];
        [addAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(icon.mas_left).mas_offset(-30);
            make.width.height.mas_equalTo(130);
            make.top.mas_equalTo(icon.mas_bottom).mas_offset(60);
            
        }];
        
        UILabel *nameLabel = [UILabel new];
        [self.contentView addSubview:nameLabel];
        nameLabel.text = @"名称:";
        nameLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addAvatar).mas_offset(5);
            make.left.mas_equalTo(icon.mas_left);
            make.top.mas_equalTo(addAvatar).mas_offset(-40);
        }];
        
        UILabel *name = [UILabel new];
        name.textColor = [UIColor colorWithHexString:@"5e544a"];
        name.font  = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:name];
        self.name = name;
        
        UILabel *priceLabel = [UILabel new];
        [self.contentView addSubview:priceLabel];
        priceLabel.text = @"价格:";
        priceLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel);
            make.left.mas_equalTo(icon.mas_right);
        }];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel);
            make.left.mas_equalTo(nameLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *price = [UILabel new];
        [self.contentView addSubview:price];
        price.textColor = [UIColor colorWithHexString:@"5e544a"];
        price.font  = [UIFont systemFontOfSize:16];
        self.price = price;
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel);
            make.left.mas_equalTo(priceLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UITextView *properties = [UITextView new];
//        properties.textColor = ;
//        properties.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//        properties.contentMode = UIViewContentModeTopLeft;
//        properties.numberOfLines = 0;
//        properties.lineBreakMode = NSLineBreakByCharWrapping;
        self.properties = properties;
        self.properties.editable = NO;
    
        self.properties.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:properties];
        [properties mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.top.mas_equalTo(name.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(price).mas_offset(-20);
            make.bottom.mas_greaterThanOrEqualTo(addAvatar);
        }];
        
        TYAttributedLabel *descLabel = [TYAttributedLabel new];
        descLabel.linesSpacing = 10.f;
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textColor = [UIColor colorWithHexString:@"676561"];
        descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel = descLabel;
        [self.contentView addSubview:descLabel];
        descLabel.preferredMaxLayoutWidth = 580;
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addAvatar);
            make.top.mas_equalTo(properties.mas_bottom).mas_offset(20);
        }];
        
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        _moviePlayer.shouldAutoplay = NO;
        [self.contentView addSubview: _moviePlayer.view];
        [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(addAvatar);
            make.width.mas_equalTo(600);
            make.height.mas_equalTo(300);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
        
        UIImageView *thumbnailImageView = [UIImageView new];
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:thumbnailImageView];
        self.thumbnailImageView = thumbnailImageView;
        [thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(addAvatar);
            make.width.mas_equalTo(600);
            make.height.mas_equalTo(300);
            make.bottom.mas_equalTo(_moviePlayer.view);
        }];
        
        _button = [UIButton new];
        _button.backgroundColor = [UIColor clearColor];
        [_button addTarget:self action:@selector(playMyVideo) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_moviePlayer.view);
            make.width.height.mas_equalTo(100);
        }];
        
        [self addNotification];
    }
    return self;
}

- (void)configModel:(CFCoffeeModel *)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatarURL] placeholderImage:[UIImage imageNamed:@"default_coffee"]];
    self.name.text = model.name;
    self.price.text = model.price;
    NSString  *msg;
    msg = [NSString stringWithFormat:@"%@",[model.properties stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"676561"]
                                 };
    self.properties.attributedText = [[NSAttributedString alloc] initWithString:msg attributes:attributes];
//    self.properties.text = msg;
    
    NSString *desc = model.desc;
    // 分割文本到数组
    NSArray *textArray = [desc componentsSeparatedByString:@"\n\t"];
    for (NSString *text in textArray) {
        if ([text containsString:@"http://"]) {//图片
            // 追加 图片Url
            TYImageStorage *imageUrlStorage = [[TYImageStorage alloc]init];
            imageUrlStorage.imageAlignment = TYImageAlignmentFill;
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:text];
            imageUrlStorage.image = image;
            imageUrlStorage.size = CGSizeMake(600, 200);
            [self.descLabel appendTextStorage:imageUrlStorage];
        }else{
            [self.descLabel appendText:text];
        }
    }
    
    if (model.videoURL) {
        _moviePlayer.contentURL = [NSURL URLWithString:model.videoURL];
        [self thumbnailImageRequest];
        _moviePlayer.view.hidden = NO;
        _thumbnailImageView.hidden = NO;
        _button.hidden = NO;
    }else{
        _moviePlayer.view.hidden = YES;
        _thumbnailImageView.hidden = YES;
        _button.hidden = YES;
    }
    [self setNeedsLayout];
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
    //    for (UIView *view in self.moviePlayer.view.subviews) {
    //        [view removeFromSuperview];
    //    }
    UIImage *image=notification.userInfo[MPMoviePlayerThumbnailImageKey];
    _thumbnailImageView.image = image;
}

/**
 *  获取视频缩略图
 */
-(void)thumbnailImageRequest {
    //获取视频开始的缩略图
    [self.moviePlayer requestThumbnailImagesAtTimes:@[@0.0,@0.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)playMyVideo {
    if (_moviePlayer.contentURL) {
        [_moviePlayer setFullscreen:YES animated:YES];
        [_moviePlayer play];
    }
}

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped: {
            NSLog(@"停止播放.");
            [_moviePlayer setFullscreen:NO animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
