/********************************************************************
 * (C) Copyright 2013 by Autodesk, Inc. All Rights Reserved. By using
 * this code,  you  are  agreeing  to the terms and conditions of the
 * License  Agreement  included  in  the documentation for this code.
 * AUTODESK  MAKES  NO  WARRANTIES,  EXPRESS  OR  IMPLIED,  AS TO THE
 * CORRECTNESS OF THIS CODE OR ANY DERIVATIVE WORKS WHICH INCORPORATE
 * IT.  AUTODESK PROVIDES THE CODE ON AN 'AS-IS' BASIS AND EXPLICITLY
 * DISCLAIMS  ANY  LIABILITY,  INCLUDING CONSEQUENTIAL AND INCIDENTAL
 * DAMAGES  FOR ERRORS, OMISSIONS, AND  OTHER  PROBLEMS IN THE  CODE.
 *
 * Use, duplication,  or disclosure by the U.S. Government is subject
 * to  restrictions  set forth  in FAR 52.227-19 (Commercial Computer
 * Software Restricted Rights) as well as DFAR 252.227-7013(c)(1)(ii)
 * (Rights  in Technical Data and Computer Software),  as applicable.
 *******************************************************************/

#import "ALAssetsLibrary+ADRACExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/NSNotificationCenter+RACSupport.h>


@implementation ALAssetsLibrary (RACExtensions)

- (RACSignal *)adrac_addAssetsGroupAlbumWithName:(NSString *)name
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self addAssetsGroupAlbumWithName:name
                              resultBlock:^(ALAssetsGroup *group) {
                                  [subscriber sendNext:group];
                                  [subscriber sendCompleted];
                              } failureBlock:^(NSError *error) {
                                  [subscriber sendError:error];
                              }];
        return nil;
    }];
    return [signal replayLazily];
}

- (RACSignal *)adrac_addObserverForChangedNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    return [notificationCenter rac_addObserverForName:ALAssetsLibraryChangedNotification
                                               object:self];
}

- (RACSignal *)adrac_assetForURL:(NSURL *)assetURL
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self assetForURL:assetURL
              resultBlock:^(ALAsset *asset) {
                  [subscriber sendNext:asset];
                  [subscriber sendCompleted];
              } failureBlock:^(NSError *error) {
                  [subscriber sendError:error];
              }];
        return nil;
    }];
    return [signal replayLazily];
}

- (RACSignal *)adrac_groupForURL:(NSURL *)groupURL
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self groupForURL:groupURL
              resultBlock:^(ALAssetsGroup *group) {
                  [subscriber sendNext:group];
                  [subscriber sendCompleted];
              } failureBlock:^(NSError *error) {
                  [subscriber sendError:error];
              }];
        return nil;
    }];
    return [signal replayLazily];
}

- (RACSignal *)adrac_writeImageDataToSavedPhotosAlbum:(NSData *)imageData
                                             metadata:(NSDictionary *)metadata
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self writeImageDataToSavedPhotosAlbum:imageData
                                      metadata:metadata
                               completionBlock:^(NSURL *assetURL, NSError *error) {
                                   if (error) {
                                       [subscriber sendError:error];
                                   } else {
                                       [subscriber sendNext:assetURL];
                                       [subscriber sendCompleted];
                                   }
                               }];
        return nil;
    }];
    return [signal replayLazily];
}

- (RACSignal *)adrac_writeImageToSavedPhotosAlbum:(CGImageRef)imageRef
                                      orientation:(ALAssetOrientation)orientation
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self writeImageToSavedPhotosAlbum:imageRef
                               orientation:orientation
                           completionBlock:^(NSURL *assetURL, NSError *error) {
                               if (error) {
                                   [subscriber sendError:error];
                               } else {
                                   [subscriber sendNext:assetURL];
                                   [subscriber sendCompleted];
                               }
                           }];
        return nil;
    }];
    return [signal replayLazily];
}

- (RACSignal *)adrac_writeVideoAtPathToSavedPhotosAlbum:(NSURL *)videoPathURL
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self writeVideoAtPathToSavedPhotosAlbum:videoPathURL
                                 completionBlock:^(NSURL *assetURL, NSError *error) {
                                     if (error) {
                                         [subscriber sendError:error];
                                     } else {
                                         [subscriber sendNext:assetURL];
                                         [subscriber sendCompleted];
                                     }
                                 }];
        return nil;
    }];
    return [signal replayLazily];
}

@end
