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

#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "ALAssetsLibrary+ADRACExtensions.h"


// TODO: Add tests for the following methods.
//
//// Returns an assets group in the result block for a URL previously retrieved from an ALAssetsGroup object.
//- (RACSignal *)adrac_groupForURL:(NSURL *)groupURL;
//
//// Saves a video identified by a given URL to the Saved Photos album.
//- (RACSignal *)adrac_writeVideoAtPathToSavedPhotosAlbum:(NSURL *)videoPathURL;


SPEC_BEGIN(ALAssetsLibrary_ADRACExtensionsSpec)

describe(@"ALAssetsLibrary+ADRACExtensions", ^{

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
            [[assetsLibrary adrac_addObserverForChangedNotification]
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
            [[assetsLibrary adrac_addAssetsGroupAlbumWithName:assetsGroupName]
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
            [[assetsLibrary adrac_writeImageToSavedPhotosAlbum:triangleImage.CGImage
                                                 orientation:ALAssetOrientationUp]
             subscribeNext:^(NSURL *assetURL) {
                 assetURLFetched = assetURL;
                 [[assetsLibrary adrac_assetForURL:assetURL]
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
                NSData *data = UIImagePNGRepresentation(squigglesImage);
                [[assetsLibrary adrac_writeImageDataToSavedPhotosAlbum:data metadata:nil]
                 subscribeNext:^(NSURL *assetURL) {
                     assetURLFetched = assetURL;
                 }];
            }
            [[expectFutureValue(assetURLFetched) shouldEventuallyBeforeTimingOutAfter(2.0f)] beNonNil];
        });
        
    });

});

SPEC_END
