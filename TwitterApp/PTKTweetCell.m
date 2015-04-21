//
//  PTKTweetCell.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 4/21/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTweetCell.h"
#import "PTKURLDataCacher.h"
#import "PTKTwitterAttributedText.h"

@interface PTKTweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaContentImageView;

@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;


@property (nonatomic) PTKURLDataCacher *cacher;


#pragma  mark abstract methods
- (void)setTextContent;
- (void)setUserIcon;
- (void)setMedia;

@end


@interface PTKSimpleTweetCell : PTKTweetCell

@end


@interface PTKMediaTweetCell : PTKTweetCell

@end



@implementation PTKTweetCell

- (PTKURLDataCacher *)cacher {
    return [PTKURLDataCacher defaultCacher];
}

- (CGFloat)preferedHeight {
    return self.bounds.size.height;
}


- (instancetype)initWithTweet:(PTKTweet *)tweet {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PtkTweetCell" owner:self options:nil];
    
    if (tweet.entities.media != nil) {
        self = nibViews.lastObject;
    } else {
        self = nibViews.firstObject;
    }
    
    if (self != nil) {
        _tweet = tweet;
        [self setTextContent];
        [self setUserIcon];
        [self setMedia];
    }
    
    return self;
}

- (void)setTextContent {
    PTKTwitterAttributedText *attributedText = [[PTKTwitterAttributedText alloc] initWithText:self.tweet.text];
    self.tweetTextLabel.text = attributedText.text;
    self.retweetLabel.text = attributedText.retweet == nil ? @"" : attributedText.retweet;
}

- (void)setUserIcon {
    NSURL *iconURL = self.tweet.iconURL;
    NSData *iconData = [self.cacher getDataForURL:iconURL elseTryLoadAsyncWithCallback:^(BOOL success, NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && data != nil) {
                self.userIconImageView.image = [UIImage imageWithData:data];
            }
        });
    }];
    if (iconData != nil) {
        self.userIconImageView.image = [UIImage imageWithData:iconData];
    }
}

- (void)setMedia { }

@end


@implementation PTKSimpleTweetCell

@end


@implementation PTKMediaTweetCell

- (void)setMedia {
    NSArray *media = self.tweet.entities.media;
    NSURL *mediaURL = [(PTKMedia *)media.firstObject media_url];
    NSData *mediaData = [self.cacher getDataForURL:mediaURL elseTryLoadAsyncWithCallback:^(BOOL success, NSData *data) {
        if (success && data != nil) {
            UIImage *mediaImage = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setMediaImageAndCalculateDifferance:mediaImage];
            });
        }
    }];
    if (mediaData != nil && self.mediaContentImageView != nil) {
        self.mediaContentImageView.image = [UIImage imageWithData:mediaData];
    }

}

- (void)setMediaImageAndCalculateDifferance:(UIImage *)mediaImage {
    self.mediaContentImageView.image = mediaImage;
}

@end