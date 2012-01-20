//
//  Constants.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 11.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#include "Constants.h"

// Online development
NSString * const CL_API_URL = @"http://cl.zurv.de";
NSString * const CL_API_ASSETSURL = @"http://cl.zurv.de/assets";

/*// Offline development
NSString * const CL_API_URL = @"http://127.0.0.1:8888/cookielicious";
NSString * const CL_API_ASSETSURL = @"http://127.0.0.1:8888/cookielicious/assets";*/

// JSON keys
NSString * const CL_API_JSON_IDKEY = @"id";
NSString * const CL_API_JSON_NAMEKEY = @"name";
NSString * const CL_API_JSON_AMOUNTKEY = @"amount";
NSString * const CL_API_JSON_UNITKEY = @"unit";
NSString * const CL_API_JSON_PREPARATIONTIMEKEY = @"preparation_time";
NSString * const CL_API_JSON_DURATIONKEY = @"duration";
NSString * const CL_API_JSON_DESCRIPTIONKEY = @"description";
NSString * const CL_API_JSON_TITLEKEY = @"title";
NSString * const CL_API_JSON_TIMEABLEKEY = @"timeable";
NSString * const CL_API_JSON_TIMERNAMEKEY = @"timer_name";
NSString * const CL_API_JSON_IMAGEKEY = @"image";
NSString * const CL_API_JSON_STEPSKEY = @"steps";
NSString * const CL_API_JSON_TODOSKEY = @"todos";
NSString * const CL_API_JSON_INGREDIENTSKEY = @"ingredients";

// Notification name
NSString * const CL_NOTIFY_FAVORITE_ADDED = @"CL_NOTIFY_FAVORITE_ADDED";

// Activity Indicator image constants
NSString * const CL_IMAGE_ACTION_FILTER = @"action_cone.png";
NSString * const CL_IMAGE_ACTION_FILTER_NO = @"action_cone_broken.png";
NSString * const CL_IMAGE_ACTION_LIVE = @"action_play.png";
NSString * const CL_IMAGE_ACTION_LIVE_NO = @"action_pause.png";
NSString * const CL_IMAGE_ACTION_FAVED = @"action_heart.png";
NSString * const CL_IMAGE_ACTION_FAVED_NO = @"action_heart_broken.png";

// Icon images contants
NSString * const CL_IMAGE_ICON_ACTION = @"icon_action.png";
NSString * const CL_IMAGE_ICON_LIVE = @"icon_play.png";
NSString * const CL_IMAGE_ICON_LIVE_NO = @"icon_pause.png";
NSString * const CL_IMAGE_ICON_CHECKMARK = @"icon_checkmark.png";
NSString * const CL_IMAGE_ICON_DELETE = @"icon_cancel.png";
NSString * const CL_IMAGE_ICON_FAVED = @"icon_heart.png";
NSString * const CL_IMAGE_ICON_FAVED_NO = @"icon_heart_faved.png";