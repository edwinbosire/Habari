//
//  MPRewardedVideoError.h
//  MoPubSDK
//
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MPRewardedVideoAdErrorUnknown = -1,

    MPRewardedVideoAdErrorTimeout = -1000,
    MPRewardedVideoAdErrorNoAdsAvailable = -1100,
    MPRewardedVideoAdErrorInvalidCustomEvent = -1200,
    MPRewardedVideoAdErrorMismatchingAdTypes = -1300,
    MPRewardedVideoAdErrorAdAlreadyPlayed = -1400,
    MPRewardedVideoAdErrorInvalidAdUnitID = -1500
} MPRewardedVideoErrorCode;

extern NSString * const MoPubRewardedVideoAdsSDKDomain;