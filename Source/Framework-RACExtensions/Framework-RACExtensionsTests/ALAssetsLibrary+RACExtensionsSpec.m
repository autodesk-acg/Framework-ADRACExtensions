//
//  ALAssetsLibrary+RACExtensionsSpec.m
//  Framework-RACExtensions
//
//  Created by Kent Wong on 10/24/2013.
//  Copyright (c) 2013 Autodesk. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "ALAssetsLibrary+RACExtensions.h"


//// Returns an assets group in the result block for a URL previously retrieved from an ALAssetsGroup object.
//- (RACSignal *)rac_groupForURL:(NSURL *)groupURL;
//
//// Saves a video identified by a given URL to the Saved Photos album.
//- (RACSignal *)rac_writeVideoAtPathToSavedPhotosAlbum:(NSURL *)videoPathURL;


SPEC_BEGIN(ALAssetsLibrary_RACExtensionsSpec)

describe(@"ALAssetsLibrary+RACExtensions", ^{

    context(@"An assets library reactive extension", ^{

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];

        NSString *triangleImagePath = [bundle pathForResource:@"triangle" ofType:@"png"];
        UIImage *triangleImage = [UIImage imageWithContentsOfFile:triangleImagePath];

        NSString *squigglesImagePath = [bundle pathForResource:@"squiggles" ofType:@"png"];
        UIImage *squigglesImage = [UIImage imageWithContentsOfFile:squigglesImagePath];

        __block ALAssetsLibrary *assetsLibrary;
        __block NSMutableArray *notificationsReceived = [NSMutableArray array];
        __block RACDisposable *changeNotificationSubscription;
        
        beforeAll(^{ // Occurs once
            assetsLibrary = [[ALAssetsLibrary alloc] init];

            changeNotificationSubscription =
            [[assetsLibrary rac_addObserverForChangedNotification]
             subscribeNext:^(NSNotification *notification) {
                 [notificationsReceived addObject:notification];
             }];
        });
        
        afterAll(^{ // Occurs once
            [changeNotificationSubscription dispose];
            changeNotificationSubscription = nil;
        });

        afterEach(^{ // Occurs after each enclosed "it"
        });
        
        it(@"Should be able to add assets groups", ^{
            __block ALAssetsGroup *assetsGroupFetched;

            // There is no way to delete this asset group from code, so we will use a unique ID for
            // the generated assets group to avoid name collisions.
            NSString *assetsGroupName = [NSString stringWithFormat:@"FRXTest_%@", ((NSUUID *)[NSUUID UUID]).UUIDString];
            [[assetsLibrary rac_addAssetsGroupAlbumWithName:assetsGroupName]
             subscribeNext:^(ALAssetsGroup *assetsGroup) {
                 assetsGroupFetched = assetsGroup;
             }];
            
            // If this fails, ensure that the test app has access to photo albums.
            [[expectFutureValue(assetsGroupFetched) shouldEventually] beNonNil];
        });
        
//        // This must be the last test in this context.
//        it(@"Should receive change notifications", ^{
//            [[expectFutureValue(theValue(notificationsReceived.count)) shouldEventually]
//             equal:theValue(1)];
//        });
        
        it(@"Should be able to write an image and retrieve its asset from its asset URL", ^{
            __block NSURL *assetURLFetched;
            __block ALAsset *assetFetched;
            [[assetsLibrary rac_writeImageToSavedPhotosAlbum:triangleImage.CGImage
                                                 orientation:ALAssetOrientationUp]
             subscribeNext:^(NSURL *assetURL) {
                 assetURLFetched = assetURL;
                 [[assetsLibrary rac_assetForURL:assetURL]
                  subscribeNext:^(ALAsset *asset) {
                      assetFetched = asset;
                  }];
             }];
            [[expectFutureValue(assetURLFetched) shouldEventuallyBeforeTimingOutAfter(2.0f)] beNonNil];
            [[expectFutureValue(assetFetched) shouldEventuallyBeforeTimingOutAfter(2.0f)] beNonNil];
        });
        
        it(@"Should be able to write an image's data", ^{
            __block NSURL *assetURLFetched;
            @autoreleasepool {
                NSData *data = UIImageJPEGRepresentation(squigglesImage, 0.9f);
                [[assetsLibrary rac_writeImageDataToSavedPhotosAlbum:data metadata:nil]
                 subscribeNext:^(NSURL *assetURL) {
                     assetURLFetched = assetURL;
                 }];
            }
            [[expectFutureValue(assetURLFetched) shouldEventuallyBeforeTimingOutAfter(2.0f)] beNonNil];
        });
        
    });

});

SPEC_END
