// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NetworkTestHelpers.h"
#import <CocoaUPnP/CocoaUPnP.h>

UPPParameters *(^InstanceParams)(void) = ^UPPParameters*(void) {
    return [UPPParameters paramsWithKey:@"InstanceID" value:@"0"];
};

void (^ExpectAndReturnErrorWithParams)(NSDictionary *, id, NSString *) = ^void (NSDictionary *params, id manager, NSString *url) {

    // This is horrible. Much cleaner in Kiwi with KWCaptureSpy :(
    [[[manager expect]
      andDo:^(NSInvocation *invocation) {
          void (^failureBlock)(NSURLSessionTask *task, NSError *error);
          [invocation getArgument:&failureBlock atIndex:7];
          failureBlock(nil, UPPErrorWithCode(UPPErrorCodeGeneric));
      }]
     POST:url
     parameters:params
     headers:nil
     progress:nil
     success:[OCMArg any]
     failure:[OCMArg any]];
};

void (^ExpectGetWithParams)(id, NSDictionary *, NSString *) = ^void(id manager, NSDictionary *params, NSString *url) {
    OCMExpect([manager POST:url parameters:params headers: nil progress:nil success:[OCMArg any] failure:[OCMArg any]]);
};

void (^RejectGetWithURL)(id, NSString *) = ^void(id manager, NSString *url) {
    [[manager reject] POST:url
                parameters:[OCMArg any]
                   headers:nil
                  progress:nil
                   success:[OCMArg any]
                   failure:[OCMArg any]];
};
