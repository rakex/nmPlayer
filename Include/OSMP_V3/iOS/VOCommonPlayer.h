/************************************************************************
VisualOn Proprietary
Copyright (c) 2013, VisualOn Incorporated. All Rights Reserved

VisualOn, Inc., 4675 Stevens Creek Blvd, Santa Clara, CA 95051, USA

All data and information contained in or disclosed by this document are
confidential and proprietary information of VisualOn, and all rights
therein are expressly reserved. By accepting this material, the
recipient agrees that this material and the information contained
therein are held in confidence and in trust. The material may only be
used and/or disclosed as authorized in a license agreement controlling
such use and disclosure.
************************************************************************/

#import <Foundation/Foundation.h>

#import "VOCommonPlayerAnalytics.h"
#import "VOCommonPlayerAssetSelection.h"
#import "VOCommonPlayerConfiguration.h"
#import "VOCommonPlayerControl.h"
#import "VOCommonPlayerDeviceInfo.h"
#import "VOCommonPlayerHTTPConfiguration.h"
#import "VOCommonPlayerRTSPConfiguration.h"
#import "VOCommonPlayerStatus.h"
#import "VOCommonPlayerSubtitle.h"

@protocol VOCommonPlayer <VOCommonPlayerAnalytics,
                            VOCommonPlayerAssetSelection,
                            VOCommonPlayerConfiguration,
                            VOCommonPlayerControl,
                            VOCommonPlayerDeviceInfo,
                            VOCommonPlayerHTTPConfiguration,
                            VOCommonPlayerRTSPConfiguration,
                            VOCommonPlayerStatus,
                            VOCommonPlayerSubtitle>

@end
