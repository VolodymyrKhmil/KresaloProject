//
//  PTKTwitterDatabaseManager.m
//  TwitterApp
//
//  Created by Vasyl Khmil on 5/11/15.
//  Copyright (c) 2015 Vasyl Khmil. All rights reserved.
//

#import "PTKTwitterDatabaseManager.h"
#import "FMDB.h"
#import "UIColor+ToString.h"
#import "NSDate+ToString.h"

static NSString * const PTKDatabaseName = @"test";
static NSString * const PTKDatabaseType = @"sqlite";

@interface PTKTwitterDatabaseManager ()

@property (nonatomic, strong) FMDatabase *database;

@end



@implementation PTKTwitterDatabaseManager

#pragma mark instance creating methods

+ (instancetype)sharedManager {
    static dispatch_once_t sharedInstanceDispatchToken;
    static PTKTwitterDatabaseManager *sharedInstance;
    dispatch_once(&sharedInstanceDispatchToken, ^{
        sharedInstance = [[PTKTwitterDatabaseManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (instancetype)initSharedInstance {
    self = [super init];
    if (self != nil) {
        [self connectToDatabase];
    }
    return self;
}

- (void)connectToDatabase {
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",
                                                                   PTKDatabaseName,
                                                                   PTKDatabaseType]];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath isDirectory:false]) {
        NSString *bundleDBPath = [[NSBundle mainBundle] pathForResource:PTKDatabaseName ofType:PTKDatabaseType];
        [[NSFileManager defaultManager] copyItemAtPath:bundleDBPath toPath:dbPath error:nil];
    }
    
    self.database = [FMDatabase databaseWithPath:dbPath];
}


#pragma mark data inserting methods

- (void)saveTweets:(NSArray *)tweets {
    for (PTKTweet *tweet in tweets) {
        [self saveTweet:tweet];
    }
}

- (void)saveTweet:(PTKTweet *)tweet {
    if ([self.database open]) {
        if (![self tweetAlreadyExistInTable:tweet]) {
            [self insertTweet:tweet];
        }
        [self.database close];
    }
}

- (BOOL)tweetAlreadyExistInTable:(PTKTweet *)tweet {
    NSString *sqlSL = [NSString stringWithFormat:@"SELECT * FROM Tweet WHERE id = %li", (long)[tweet.id integerValue]];
    FMResultSet *resultSet = [self.database executeQuery:sqlSL];
    return [resultSet next];
}

- (void)insertTweet:(PTKTweet *)tweet {
    NSString *text      = tweet.text;
    NSNumber *id        = tweet.id;
    NSString *created_at  = [tweet.created_at stringValue];
    
    NSString *sqlSL = @"INSERT INTO Tweet VALUES (:text, :created_at, :id)";
    NSDictionary *paramethers = @{
                                  @"id"         : id,
                                  @"text"       : text,
                                  @"created_at" : created_at};
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
    
    
    [self insertEntities:tweet.entities withTweetPK:tweet.id];
    [self insertUser:tweet.user withTweetPK:tweet.id];
}

- (void)insertUser:(PTKUser *)user withTweetPK:(NSNumber *)tweetPK {
    NSString *profile_image_url     = user.profile_image_url.absoluteString;
    NSString *profile_link_url      = [user.profile_link_color stringValue];
    NSString *profile_text_color    = [user.profile_text_color stringValue];
    NSString *created_at            = [user.created_at stringValue];
    NSNull *user_id                 = [NSNull null];
    NSString *name                  = user.name;
    NSNumber *user_tweet            = tweetPK;
    
    NSString *sqlSL = @"INSERT INTO User VALUES (:profile_image_url, :profile_link_color, :profile_text_color, :created_at, :user_id, :user_tweet, :name)";
    NSDictionary *paramethers = @{@"profile_image_url"  : profile_image_url,
                                  @"profile_link_color" : profile_link_url,
                                  @"profile_text_color" : profile_text_color,
                                  @"created_at"         : created_at,
                                  @"user_id"            : user_id,
                                  @"user_tweet"         : user_tweet,
                                  @"name"               : name};
    
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
}

- (void)insertEntities:(PTKEntities *)entities withTweetPK:(NSNumber *)tweetPK {
    NSNull *entities_id         = [NSNull null];
    NSNumber *entities_tweet    = tweetPK;
    
    NSString *sqlSL = @"INSERT INTO Entities VALUES (:entities_id, :entities_tweet)";
    
    NSDictionary *paramethers = @{@"entities_id"    : entities_id,
                                @"entities_tweet"   : entities_tweet};
    
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT entities_id FROM ENTITIES WHERE entities_tweet = %li", (long)entities_tweet.integerValue]];
    if ([resultSet next]) {
        
        for (PTKURL *url in entities.urls) {
            [self insertURL:url withEntitiesPK:[NSNumber numberWithInt:[resultSet intForColumnIndex:0]]];
        }
        
        for (PTKMedia *media in entities.media) {
            [self insertMedia:media withEntitiesPK:[NSNumber numberWithInt:[resultSet intForColumnIndex:0]]];
        }
        
        for (PTKHashTag *hashTag in entities.hashtags) {
            [self insertHashTag:hashTag withEntitiesPK:[NSNumber numberWithInt:[resultSet intForColumnIndex:0]]];
        }
    }
}

- (void)insertURL:(PTKURL *)url withEntitiesPK:(NSNumber *)entitiesPK {
    NSString *display_url       = url.display_url;
    NSString *expanded_url      = url.expanded_url;
    NSNumber *indicies_start    = url.indices.firstObject;
    NSNumber *indicies_end      = url.indices.lastObject;
    NSNumber *url_entities      = entitiesPK;
    
    NSString *sqlSL = @"INSERT INTO URL VALUES (:display_url, :expanded_url, :indicies_start, :indicies_end, :url_entities)";
    
    NSDictionary *paramethers = @{@"display_url"    : display_url,
                                  @"expanded_url"   : expanded_url,
                                  @"indicies_start" : indicies_start,
                                  @"indicies_end"   : indicies_end,
                                  @"url_entities"   : url_entities};
    
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
}

- (void)insertMedia:(PTKMedia *)media withEntitiesPK:(NSNumber *)entitiesPK {
    NSString *media_url         = media.media_url.absoluteString;
    NSNumber *media_entities    = entitiesPK;
    
    NSString *sqlSL = @"INSERT INTO Media VALUES (:media_url, :media_entities)";
    
    NSDictionary *paramethers = @{@"media_url"      : media_url,
                                  @"media_entities" : media_entities};
    
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
}

- (void)insertHashTag:(PTKHashTag *)hashTag withEntitiesPK:(NSNumber *)entitiesPK {
    NSString *text              = hashTag.text;
    NSNumber *indicies_start    = hashTag.indices.firstObject;
    NSNumber *indicies_end      = hashTag.indices.lastObject;
    NSNumber *hashtag_entities  = entitiesPK;
    
    NSString *sqlSL = @"INSERT INTO HashTag VALUES (:text, :indicies_start, :indicies_end, :hashtag_entities)";
    
    NSDictionary *paramethers = @{@"text"               : text,
                                  @"indicies_start"     : indicies_start,
                                  @"indicies_end"       : indicies_end,
                                  @"hashtag_entities"   : hashtag_entities};
    
    [self.database executeUpdate:sqlSL withParameterDictionary:paramethers];
}


#pragma mark data getting methods

- (NSArray *)allTweets {
    NSMutableArray *takenTweets = [NSMutableArray new];
    
    if ([self.database open]) {
        
        FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM Tweet"];
        
        while ([resultSet next]) {
            PTKTweet *tweet = [PTKTweet new];
            tweet.text = [resultSet stringForColumn:@"text"];
            tweet.id = [NSNumber numberWithInteger:[resultSet stringForColumn:@"id"].integerValue];
            tweet.created_at = [NSDate dateWithString:[resultSet stringForColumn:@"created_at"]];
            tweet.user = [self userForTweetWithPK:tweet.id.integerValue];
            tweet.entities = [self entitiesFotTweetWithPK:[tweet.id integerValue]];
            
            [takenTweets addObject:tweet];
        }
        
        [self.database close];
        
        [takenTweets sortedArrayUsingComparator:^NSComparisonResult(PTKTweet *obj1, PTKTweet *obj2) {
            return [obj1.created_at compare:obj2.created_at];
        }];
    }
    return takenTweets;
}

- (PTKUser *)userForTweetWithPK:(NSInteger)tweetPK {
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM User WHERE user_tweet = %li", (long)tweetPK]];
   
    PTKUser *user;
    if ([resultSet next]) {
        user = [PTKUser new];
        
        user.created_at = [NSDate dateWithString:[resultSet stringForColumn:@"created_at"]];
        user.profile_image_url = [NSURL URLWithString:[resultSet stringForColumn:@"profile_image_url"]];
        user.profile_link_color = [UIColor colorWithString:[resultSet stringForColumn:@"profile_link_color"]];
        user.profile_text_color = [UIColor colorWithString:[resultSet stringForColumn:@"profile_text_color"]];
        user.name = [resultSet stringForColumn:@"name"];
        return user;
    }
    
    return user;
}

- (PTKEntities *)entitiesFotTweetWithPK:(NSInteger)tweetPK {
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM Entities WHERE entities_tweet = %li", (long)tweetPK]];
    
    PTKEntities *entities;
    if ([resultSet next]) {
        entities = [PTKEntities new];
        NSInteger entitiesPK = [resultSet intForColumn:@"entities_id"];
        
        entities.media = [self mediaForEntitiesWithPK:entitiesPK];
        entities.urls = [self urlsForEntitiesWithPK:entitiesPK];
        entities.hashtags = [self hashTagsForEntitiesWithPK:entitiesPK];
    }
    
    return entities;
}

- (NSArray *)mediaForEntitiesWithPK:(NSInteger)entitiesPK {
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM Media WHERE media_entities = %li", (long)entitiesPK]];
    
    while ([resultSet next]) {
        NSMutableArray *media = [NSMutableArray new];
        PTKMedia *mediaObject = [PTKMedia new];
        mediaObject.media_url = [NSURL URLWithString:[resultSet stringForColumn:@"media_url"]];
        [media addObject:mediaObject];
        return media;
    }
    
    return nil;
}

- (NSArray *)urlsForEntitiesWithPK:(NSInteger)entitiesPK {
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM URL WHERE url_entities = %li", (long)entitiesPK]];
    
    while ([resultSet next]) {
        NSMutableArray *urls = [NSMutableArray new];
        PTKURL *urlObject = [PTKURL new];
        urlObject.expanded_url = [resultSet stringForColumn:@"expanded_url"];
        urlObject.display_url = [resultSet stringForColumn:@"display_url"];
        
        int startIndex = [resultSet intForColumn:@"indicies_start"];
        int endIndex = [resultSet intForColumn:@"indicies_end"];
        urlObject.indices = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:startIndex],
                                                            [NSNumber numberWithInt:endIndex], nil];
        [urls addObject:urlObject];
        return urls;
    }
    
    return nil;
}

- (NSArray *)hashTagsForEntitiesWithPK:(NSInteger)entitiesPK {
    
    FMResultSet *resultSet = [self.database executeQuery:[NSString stringWithFormat:@"SELECT * FROM HashTag WHERE hashtag_entities = %li", (long)entitiesPK]];
    
    while ([resultSet next]) {
        NSMutableArray *hashTags = [NSMutableArray new];
        PTKHashTag *hashTagObject = [PTKHashTag new];
        
        hashTagObject.text = [resultSet stringForColumn:@"text"];
        
        int startIndex = [resultSet intForColumn:@"indicies_start"];
        int endIndex = [resultSet intForColumn:@"indicies_end"];
        hashTagObject.indices = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:startIndex],
                                                                [NSNumber numberWithInt:endIndex], nil];
        
        [hashTags addObject:hashTagObject];
        return  hashTags;
    }
    
    return nil;
}

@end
