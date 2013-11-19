//
//  LoadURLJson.m
//  Stadium
//
//  Created by William L. Schreiber on 6/18/13.
//  Copyright (c) 2013 Stadium Stock Exchange. All rights reserved.
//

#import "LoadURLJson.h"
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)

@implementation LoadURLJson

@synthesize receivedData, delegate, urlString, urlMethod, urlParameters;

+ (id) download:(NSString *)aURLString withDelegate:(id <LoadJsonDelegate>)aDelegate withMethod:(NSString *)method withParameters:(NSString *)parameters
{
    if (!aURLString)
    {
        NSLog(@"Error. No URL string");
        return nil;
    }
    
    NSString* baseURL = @"http://practice-scoop.herokuapp.com";
    NSString* baseParameters = @"&sk=foeiuh9q28734gfa9w8hfg92830rq892g0oaw8hf";
    
    LoadURLJson *loadJson = [[self alloc] init];
    if ([method isEqualToString:@"GET"]) {
        loadJson.urlString = [NSString stringWithFormat:@"%@%@%@", baseURL, aURLString, baseParameters ];
    }else if ([method isEqualToString:@"PUT"]) {
        loadJson.urlString = [NSString stringWithFormat:@"%@%@%@", baseURL, aURLString, baseParameters ];
    }else {
        loadJson.urlString = [NSString stringWithFormat:@"%@%@", baseURL, aURLString ];
    }
    loadJson.delegate = aDelegate;
    loadJson.urlMethod = method;
    loadJson.urlParameters = [NSString stringWithFormat:@"%@%@", parameters, baseParameters];
    [loadJson start];
    
    NSLog(@"%@", loadJson.urlString);
    
    return loadJson;
}

-(void)start
{
    receivedData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:urlMethod];
    if ([urlMethod isEqualToString:@"POST"]) {
        NSString *postString = urlParameters;
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    [connection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    
    // Check for bad connection
    expectedLength = [response expectedContentLength];
    if (expectedLength == NSURLResponseUnknownLength)
    {
        NSString *reason = [NSString stringWithFormat:@"Invalid URL [%@]", urlString];
        SAFE_PERFORM_WITH_ARG(delegate, @selector(dataDownloadFailed:), reason);
        [connection cancel];
        [self cleanup];
        return;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    SAFE_PERFORM_WITH_ARG(delegate, @selector(downloadReceivedData), nil);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SAFE_PERFORM_WITH_ARG(delegate, @selector(downloadFinished), nil);
}

-(void)cleanup
{
    self.urlString = nil;
}

-(void)dealloc
{
    [self cleanup];
}

-(void)cancel
{
    [self cleanup];
}

@end
