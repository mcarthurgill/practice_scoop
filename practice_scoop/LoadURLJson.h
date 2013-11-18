//
//  LoadURLJson.h
//  Stadium
//
//  Created by William L. Schreiber on 6/18/13.
//  Copyright (c) 2013 Stadium Stock Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadJsonDelegate <NSObject, NSURLConnectionDelegate>
@optional
- (void) downloadFinished;
- (void) downloadReceivedData;
- (void) dataDownloadFailed: (NSString *) reason;
@end

@interface LoadURLJson : NSObject
{
    NSMutableData *receivedData;
    int expectedLength;
}

@property (nonatomic, strong) NSMutableData *receivedData;
@property (strong) NSString *urlString;
@property (strong) NSString *urlMethod;
@property (strong) NSString *urlParameters;
@property (weak) id <LoadJsonDelegate> delegate;

-(void)start;
-(void)cancel;

+ (id)download:(NSString *)aURLString withDelegate:(id <LoadJsonDelegate>)aDelegate withMethod:(NSString *)method withParameters:(NSString *)parameters;

@end
