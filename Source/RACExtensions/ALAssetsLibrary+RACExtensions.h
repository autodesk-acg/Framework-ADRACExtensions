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

#import <AssetsLibrary/AssetsLibrary.h>

@class RACSignal;


@interface ALAssetsLibrary (RACExtensions)

// Adds a new assets group to the library and sends an (ALAssetsGroup *) only once.
- (RACSignal *)rac_addAssetsGroupAlbumWithName:(NSString *)name;

// Sends an (NSNotification *) every time the contents of the assets
// library has changed from under the app that is using the data.
// e.g.
//    @weakify(self);
//    [[assetsLibrary rac_addObserverForChangedNotification]
//     subscribeNext:^(NSNotification *changedNotification) {
//         @strongify(self);
//         // Do something with the notification.
//     }];
- (RACSignal *)rac_addObserverForChangedNotification;

// Sends the (ALAsset *) referenced by assetURL only once.
- (RACSignal *)rac_assetForURL:(NSURL *)assetURL;

// Returns an assets group in the result block for a URL previously retrieved from an ALAssetsGroup object.
- (RACSignal *)rac_groupForURL:(NSURL *)groupURL;

// Writes given image data and metadata to the Photos Album.
- (RACSignal *)rac_writeImageDataToSavedPhotosAlbum:(NSData *)imageData
                                           metadata:(NSDictionary *)metadata;

// Saves a given image to the Saved Photos album.
- (RACSignal *)rac_writeImageToSavedPhotosAlbum:(CGImageRef)imageRef
                                    orientation:(ALAssetOrientation)orientation;

// Saves a video identified by a given URL to the Saved Photos album.
- (RACSignal *)rac_writeVideoAtPathToSavedPhotosAlbum:(NSURL *)videoPathURL;

@end
