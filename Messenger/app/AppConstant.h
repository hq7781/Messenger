//
// Copyright (c) 2016 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		SYSTEM_VERSION								[[UIDevice currentDevice] systemVersion]
#define		SYSTEM_VERSION_EQUAL_TO(v)					([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedSame)
#define		SYSTEM_VERSION_GREATER_THAN(v)				([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedDescending)
#define		SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)	([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define		SYSTEM_VERSION_LESS_THAN(v)					([SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#define		SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)		([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedDescending)
//-------------------------------------------------------------------------------------------------------------------------------------------------
#if 1 //NEW
//-------------------------------------------------------------------------------------------------------------------------------------------------
extern NSString * const FIREBASE_STORAGE;
//-------------------------------------------------------------------------------------------------------------------------------------------------
extern NSString * const ONESIGNAL_APPID;
//-------------------------------------------------------------------------------------------------------------------------------------------------
extern NSString * const SINCH_HOST;
extern NSString * const SINCH_KEY;
extern NSString * const SINCH_SECRET;
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
extern NSString * const PHONE_LOGIN_DOMAIN;
extern NSString * const PHONE_LOGIN_PASSWORD;
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		VERSION_CUSTOM
#define		VERSION_PREMIUM
//---------------------------------------------------------------------------------
extern int const DEFAULT_TAB;
extern int const DEFAULT_COUNTRY;
//---------------------------------------------------------------------------------
extern int const VIDEO_LENGTH;
extern int const AUDIO_LENGTH;
extern int const INSERT_MESSAGES;
extern int const DOWNLOAD_TIMEOUT;
//---------------------------------------------------------------------------------
extern int const STATUS_LOADING;
extern int const STATUS_SUCCEED;
extern int const STATUS_MANUAL;
//---------------------------------------------------------------------------------
extern int const MEDIA_IMAGE;
extern int const MEDIA_VIDEO;
extern int const MEDIA_AUDIO;
//---------------------------------------------------------------------------------
extern int const NETWORK_MANUAL;
extern int const NETWORK_WIFI;
extern int const NETWORK_ALL;
//---------------------------------------------------------------------------------
extern int const KEEPMEDIA_WEEK;
extern int const KEEPMEDIA_MONTH;
extern int const KEEPMEDIA_FOREVER;
//---------------------------------------------------------------------------------
extern int const DEL_ACCOUNT_NONE;
extern int const DEL_ACCOUNT_ONE;
extern int const DEL_ACCOUNT_ALL;
//---------------------------------------------------------------------------------
extern NSString * const CALLHISTORY_AUDIO;
extern NSString * const CALLHISTORY_VIDEO;
//---------------------------------------------------------------------------------
extern NSString * const MESSAGE_STATUS;
extern NSString * const MESSAGE_TEXT;
extern NSString * const MESSAGE_EMOJI;
extern NSString * const MESSAGE_PICTURE;
extern NSString * const MESSAGE_VIDEO;
extern NSString * const MESSAGE_AUDIO;
extern NSString * const MESSAGE_LOCATION;
//---------------------------------------------------------------------------------
extern NSString * const LOGIN_EMAIL;//							@"Email"
extern NSString * const LOGIN_FACEBOOK;//						@"Facebook"
extern NSString * const LOGIN_GOOGLE;//						@"Google"
extern NSString * const LOGIN_PHONE;//							@"Phone"
//---------------------------------------------------------------------------------
#define		COLOR_OUTGOING						HEXCOLOR(0x007AFFFF)
#define		COLOR_INCOMING						HEXCOLOR(0xE6E5EAFF)
//---------------------------------------------------------------------------------
#define		COLOR_NAVIGATION_TEXT				[UIColor whiteColor]
#define		COLOR_NAVIGATION_BACKGROUND			HEXCOLOR(0x7FBB00FF)
//---------------------------------------------------------------------------------
extern NSString * const TEXT_QUEUED;//							@"Queued"
extern NSString * const TEXT_SENT;//							@"Sent"
extern NSString * const TEXT_READ;//							@"Read"
//---------------------------------------------------------------------------------
extern NSString * const PHOTOS_ALBUM_TITLE;//					@"Chat"
//---------------------------------------------------------------------------------
extern NSString * const LINK_PREMIUM;//			@"http://www.relatedcode.com/premium"
//---------------------------------------------------------------------------------
#define		SCREEN_WIDTH						[UIScreen mainScreen].bounds.size.width
#define		SCREEN_HEIGHT						[UIScreen mainScreen].bounds.size.height
//---------------------------------------------------------------------------------
#define		TEXT_SHARE_APP						@"Check out PremiumChat for your smartphone. Download it today."
#define		TEXT_INVITE_SMS						@"Check out PremiumChat for your smartphone. Download it today."
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		FUSER_PATH							@"User"					//	Path name
#define		FUSER_OBJECTID						@"objectId"				//	String

#define		FUSER_EMAIL							@"email"				//	String
#define		FUSER_PHONE							@"phone"				//	String

#define		FUSER_FIRSTNAME						@"firstname"			//	String
#define		FUSER_LASTNAME						@"lastname"				//	String
#define		FUSER_FULLNAME						@"fullname"				//	String
#define		FUSER_COUNTRY						@"country"				//	String
#define		FUSER_LOCATION						@"location"				//	String
#define		FUSER_STATUS						@"status"				//	String

#define		FUSER_PICTURE						@"picture"				//	String
#define		FUSER_THUMBNAIL						@"thumbnail"			//	String

#define		FUSER_KEEPMEDIA						@"keepMedia"			//	Number
#define		FUSER_NETWORKIMAGE					@"networkImage"			//	Number
#define		FUSER_NETWORKVIDEO					@"networkVideo"			//	Number
#define		FUSER_NETWORKAUDIO					@"networkAudio"			//	Number
#define		FUSER_AUTOSAVEMEDIA					@"autoSaveMedia"		//	Boolean
#define		FUSER_WALLPAPER						@"wallpaper"			//	String

#define		FUSER_LOGINMETHOD					@"loginMethod"			//	String
#define		FUSER_ONESIGNALID					@"oneSignalId"			//	String

#define		FUSER_LASTACTIVE					@"lastActive"			//	Timestamp
#define		FUSER_LASTTERMINATE					@"lastTerminate"		//	Timestamp

#define		FUSER_CREATEDAT						@"createdAt"			//	Timestamp
#define		FUSER_UPDATEDAT						@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FBLOCKED_PATH						@"Blocked"				//	Path name
#define		FBLOCKED_OBJECTID					@"objectId"				//	String

#define		FBLOCKED_BLOCKEDID					@"blockedId"			//	String
#define		FBLOCKED_USERID						@"userId"				//	String

#define		FBLOCKED_ISDELETED					@"isDeleted"			//	Boolean

#define		FBLOCKED_CREATEDAT					@"createdAt"			//	Timestamp
#define		FBLOCKED_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FCALLHISTORY_PATH					@"CallHistory"			//	Path name
#define		FCALLHISTORY_OBJECTID				@"objectId"				//	String

#define		FCALLHISTORY_INITIATORID			@"initiatorId"			//	String
#define		FCALLHISTORY_RECIPIENTID			@"recipientId"			//	String
#define		FCALLHISTORY_PHONENUMBER			@"phoneNumber"			//	String

#define		FCALLHISTORY_TYPE					@"type"					//	String
#define		FCALLHISTORY_TEXT					@"text"					//	String

#define		FCALLHISTORY_STATUS					@"status"				//	String
#define		FCALLHISTORY_DURATION				@"duration"				//	Number

#define		FCALLHISTORY_STARTEDAT				@"startedAt"			//	Timestamp
#define		FCALLHISTORY_ESTABLISHEDAT			@"establishedAt"		//	Timestamp
#define		FCALLHISTORY_ENDEDAT				@"endedAt"				//	Timestamp

#define		FCALLHISTORY_ISDELETED				@"isDeleted"			//	Boolean

#define		FCALLHISTORY_CREATEDAT				@"createdAt"			//	Timestamp
#define		FCALLHISTORY_UPDATEDAT				@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FGROUP_PATH							@"Group"				//	Path name
#define		FGROUP_OBJECTID						@"objectId"				//	String

#define		FGROUP_USERID						@"userId"				//	String
#define		FGROUP_NAME							@"name"					//	String
#define		FGROUP_PICTURE						@"picture"				//	String
#define		FGROUP_MEMBERS						@"members"				//	Array

#define		FGROUP_ISDELETED					@"isDeleted"			//	Boolean

#define		FGROUP_CREATEDAT					@"createdAt"			//	Timestamp
#define		FGROUP_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FMESSAGE_PATH						@"Message"				//	Path name
#define		FMESSAGE_OBJECTID					@"objectId"				//	String

#define		FMESSAGE_CHATID						@"chatId"				//	String
#define		FMESSAGE_MEMBERS					@"members"				//	Array

#define		FMESSAGE_SENDERID					@"senderId"				//	String
#define		FMESSAGE_SENDERNAME					@"senderName"			//	String
#define		FMESSAGE_SENDERINITIALS				@"senderInitials"		//	String
#define		FMESSAGE_SENDERPICTURE				@"senderPicture"		//	String

#define		FMESSAGE_RECIPIENTID				@"recipientId"			//	String
#define		FMESSAGE_RECIPIENTNAME				@"recipientName"		//	String
#define		FMESSAGE_RECIPIENTINITIALS			@"recipientInitials"	//	String
#define		FMESSAGE_RECIPIENTPICTURE			@"recipientPicture"		//	String

#define		FMESSAGE_GROUPID					@"groupId"				//	String
#define		FMESSAGE_GROUPNAME					@"groupName"			//	String
#define		FMESSAGE_GROUPPICTURE				@"groupPicture"			//	String

#define		FMESSAGE_TYPE						@"type"					//	String
#define		FMESSAGE_TEXT						@"text"					//	String

#define		FMESSAGE_PICTURE					@"picture"				//	String
#define		FMESSAGE_PICTURE_WIDTH				@"picture_width"		//	Number
#define		FMESSAGE_PICTURE_HEIGHT				@"picture_height"		//	Number
#define		FMESSAGE_PICTURE_MD5				@"picture_md5"			//	String

#define		FMESSAGE_VIDEO						@"video"				//	String
#define		FMESSAGE_VIDEO_DURATION				@"video_duration"		//	Number
#define		FMESSAGE_VIDEO_MD5					@"video_md5"			//	String

#define		FMESSAGE_AUDIO						@"audio"				//	String
#define		FMESSAGE_AUDIO_DURATION				@"audio_duration"		//	Number
#define		FMESSAGE_AUDIO_MD5					@"audio_md5"			//	String

#define		FMESSAGE_LATITUDE					@"latitude"				//	Number
#define		FMESSAGE_LONGITUDE					@"longitude"			//	Number

#define		FMESSAGE_STATUS						@"status"				//	String
#define		FMESSAGE_ISDELETED					@"isDeleted"			//	Boolean

#define		FMESSAGE_CREATEDAT					@"createdAt"			//	Timestamp
#define		FMESSAGE_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FLASTREAD_PATH						@"LastRead"				//	Path name
#define		FMUTEDUNTIL_PATH					@"MutedUntil"			//	Path name
//---------------------------------------------------------------------------------
#define		FSTATUS_PATH						@"Status"				//	Path name
#define		FSTATUS_OBJECTID					@"objectId"				//	String

#define		FSTATUS_CHATID						@"chatId"				//	String
#define		FSTATUS_LASTREAD					@"lastRead"				//	Timestamp
#define		FSTATUS_MUTEDUNTIL					@"mutedUntil"			//	Timestamp

#define		FSTATUS_CREATEDAT					@"createdAt"			//	Timestamp
#define		FSTATUS_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FTYPING_PATH						@"Typing"				//	Path name
//---------------------------------------------------------------------------------
#define		FUSERSTATUS_PATH					@"UserStatus"			//	Path name
#define		FUSERSTATUS_OBJECTID				@"objectId"				//	String

#define		FUSERSTATUS_NAME					@"name"					//	String

#define		FUSERSTATUS_CREATEDAT				@"createdAt"			//	Timestamp
#define		FUSERSTATUS_UPDATEDAT				@"updatedAt"			//	Timestamp
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		ONESIGNALID							@"OneSignalId"
#define		USER_ACCOUNTS						@"UserAccounts"
#define		REACHABILITY_CHANGED				@"ReachabilityChanged"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NotificationAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NotificationUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NotificationUserLoggedOut"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_REFRESH_BLOCKEDS		@"NotificationRefreshBlockeds"
#define		NOTIFICATION_REFRESH_CALLHISTORIES	@"NotificationRefreshCallHistories"
#define		NOTIFICATION_REFRESH_CHATS			@"NotificationRefreshChats"
#define		NOTIFICATION_REFRESH_CONTACTS		@"NotificationRefreshContacts"
#define		NOTIFICATION_REFRESH_GROUPS			@"NotificationRefreshGroups"
#define		NOTIFICATION_REFRESH_MESSAGES1		@"NotificationRefreshMessages1"
#define		NOTIFICATION_REFRESH_MESSAGES2		@"NotificationRefreshMessages2"
#define		NOTIFICATION_REFRESH_STATUSES		@"NotificationRefreshStatuses"
#define		NOTIFICATION_REFRESH_USERS			@"NotificationRefreshUsers"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_CLEANUP_CHATVIEW		@"NotificationCleanupChatView"
//-------------------------------------------------------------------------------------------------------------------------------------------------

#else
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		FIREBASE_STORAGE					@"gs://related31-21f6e.appspot.com"
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		ONESIGNAL_APPID						@"15cad58e-b84c-47e1-a29b-932e88457132"
//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		SINCH_HOST							@"sandbox.sinch.com"
#define		SINCH_KEY							@"b515eb8b-dcaf-473d-982a-81c5a97a3a1e"
#define		SINCH_SECRET						@"mgnwHKZLIkahFoj90UsbCg=="
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		PHONE_LOGIN_DOMAIN					@"yourdomain.com"
#define		PHONE_LOGIN_PASSWORD				@"Q0wD3gtRv73Olz6E8g8G"
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		VERSION_CUSTOM
#define		VERSION_PREMIUM
//---------------------------------------------------------------------------------
#define		DEFAULT_TAB							0
#define		DEFAULT_COUNTRY						84
//---------------------------------------------------------------------------------
#define		VIDEO_LENGTH						5
#define		AUDIO_LENGTH						5
#define		INSERT_MESSAGES						10
#define		DOWNLOAD_TIMEOUT					300
//---------------------------------------------------------------------------------
#define		STATUS_LOADING						1
#define		STATUS_SUCCEED						2
#define		STATUS_MANUAL						3
//---------------------------------------------------------------------------------
#define		MEDIA_IMAGE							1
#define		MEDIA_VIDEO							2
#define		MEDIA_AUDIO							3
//---------------------------------------------------------------------------------
#define		NETWORK_MANUAL						1
#define		NETWORK_WIFI						2
#define		NETWORK_ALL							3
//---------------------------------------------------------------------------------
#define		KEEPMEDIA_WEEK						1
#define		KEEPMEDIA_MONTH						2
#define		KEEPMEDIA_FOREVER					3
//---------------------------------------------------------------------------------
#define		DEL_ACCOUNT_NONE					1
#define		DEL_ACCOUNT_ONE						2
#define		DEL_ACCOUNT_ALL						3
//---------------------------------------------------------------------------------
#define		CALLHISTORY_AUDIO					@"audio"
#define		CALLHISTORY_VIDEO					@"video"
//---------------------------------------------------------------------------------
#define		MESSAGE_STATUS						@"status"
#define		MESSAGE_TEXT						@"text"
#define		MESSAGE_EMOJI						@"emoji"
#define		MESSAGE_PICTURE						@"picture"
#define		MESSAGE_VIDEO						@"video"
#define		MESSAGE_AUDIO						@"audio"
#define		MESSAGE_LOCATION					@"location"
//---------------------------------------------------------------------------------
#define		LOGIN_EMAIL							@"Email"
#define		LOGIN_FACEBOOK						@"Facebook"
#define		LOGIN_GOOGLE						@"Google"
#define		LOGIN_PHONE							@"Phone"
//---------------------------------------------------------------------------------
#define		COLOR_OUTGOING						HEXCOLOR(0x007AFFFF)
#define		COLOR_INCOMING						HEXCOLOR(0xE6E5EAFF)
//---------------------------------------------------------------------------------
#define		COLOR_NAVIGATION_TEXT				[UIColor whiteColor]
#define		COLOR_NAVIGATION_BACKGROUND			HEXCOLOR(0x7FBB00FF)
//---------------------------------------------------------------------------------
#define		TEXT_QUEUED							@"Queued"
#define		TEXT_SENT							@"Sent"
#define		TEXT_READ							@"Read"
//---------------------------------------------------------------------------------
#define		PHOTOS_ALBUM_TITLE					@"Chat"
//---------------------------------------------------------------------------------
#define		LINK_PREMIUM						@"http://www.relatedcode.com/premium"
//---------------------------------------------------------------------------------
#define		SCREEN_WIDTH						[UIScreen mainScreen].bounds.size.width
#define		SCREEN_HEIGHT						[UIScreen mainScreen].bounds.size.height
//---------------------------------------------------------------------------------
#define		TEXT_SHARE_APP						@"Check out PremiumChat for your smartphone. Download it today."
#define		TEXT_INVITE_SMS						@"Check out PremiumChat for your smartphone. Download it today."
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		FUSER_PATH							@"User"					//	Path name
#define		FUSER_OBJECTID						@"objectId"				//	String

#define		FUSER_EMAIL							@"email"				//	String
#define		FUSER_PHONE							@"phone"				//	String

#define		FUSER_FIRSTNAME						@"firstname"			//	String
#define		FUSER_LASTNAME						@"lastname"				//	String
#define		FUSER_FULLNAME						@"fullname"				//	String
#define		FUSER_COUNTRY						@"country"				//	String
#define		FUSER_LOCATION						@"location"				//	String
#define		FUSER_STATUS						@"status"				//	String

#define		FUSER_PICTURE						@"picture"				//	String
#define		FUSER_THUMBNAIL						@"thumbnail"			//	String

#define		FUSER_KEEPMEDIA						@"keepMedia"			//	Number
#define		FUSER_NETWORKIMAGE					@"networkImage"			//	Number
#define		FUSER_NETWORKVIDEO					@"networkVideo"			//	Number
#define		FUSER_NETWORKAUDIO					@"networkAudio"			//	Number
#define		FUSER_AUTOSAVEMEDIA					@"autoSaveMedia"		//	Boolean
#define		FUSER_WALLPAPER						@"wallpaper"			//	String

#define		FUSER_LOGINMETHOD					@"loginMethod"			//	String
#define		FUSER_ONESIGNALID					@"oneSignalId"			//	String

#define		FUSER_LASTACTIVE					@"lastActive"			//	Timestamp
#define		FUSER_LASTTERMINATE					@"lastTerminate"		//	Timestamp

#define		FUSER_CREATEDAT						@"createdAt"			//	Timestamp
#define		FUSER_UPDATEDAT						@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FBLOCKED_PATH						@"Blocked"				//	Path name
#define		FBLOCKED_OBJECTID					@"objectId"				//	String

#define		FBLOCKED_BLOCKEDID					@"blockedId"			//	String
#define		FBLOCKED_USERID						@"userId"				//	String

#define		FBLOCKED_ISDELETED					@"isDeleted"			//	Boolean

#define		FBLOCKED_CREATEDAT					@"createdAt"			//	Timestamp
#define		FBLOCKED_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FCALLHISTORY_PATH					@"CallHistory"			//	Path name
#define		FCALLHISTORY_OBJECTID				@"objectId"				//	String

#define		FCALLHISTORY_INITIATORID			@"initiatorId"			//	String
#define		FCALLHISTORY_RECIPIENTID			@"recipientId"			//	String
#define		FCALLHISTORY_PHONENUMBER			@"phoneNumber"			//	String

#define		FCALLHISTORY_TYPE					@"type"					//	String
#define		FCALLHISTORY_TEXT					@"text"					//	String

#define		FCALLHISTORY_STATUS					@"status"				//	String
#define		FCALLHISTORY_DURATION				@"duration"				//	Number

#define		FCALLHISTORY_STARTEDAT				@"startedAt"			//	Timestamp
#define		FCALLHISTORY_ESTABLISHEDAT			@"establishedAt"		//	Timestamp
#define		FCALLHISTORY_ENDEDAT				@"endedAt"				//	Timestamp

#define		FCALLHISTORY_ISDELETED				@"isDeleted"			//	Boolean

#define		FCALLHISTORY_CREATEDAT				@"createdAt"			//	Timestamp
#define		FCALLHISTORY_UPDATEDAT				@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FGROUP_PATH							@"Group"				//	Path name
#define		FGROUP_OBJECTID						@"objectId"				//	String

#define		FGROUP_USERID						@"userId"				//	String
#define		FGROUP_NAME							@"name"					//	String
#define		FGROUP_PICTURE						@"picture"				//	String
#define		FGROUP_MEMBERS						@"members"				//	Array

#define		FGROUP_ISDELETED					@"isDeleted"			//	Boolean

#define		FGROUP_CREATEDAT					@"createdAt"			//	Timestamp
#define		FGROUP_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FMESSAGE_PATH						@"Message"				//	Path name
#define		FMESSAGE_OBJECTID					@"objectId"				//	String

#define		FMESSAGE_CHATID						@"chatId"				//	String
#define		FMESSAGE_MEMBERS					@"members"				//	Array

#define		FMESSAGE_SENDERID					@"senderId"				//	String
#define		FMESSAGE_SENDERNAME					@"senderName"			//	String
#define		FMESSAGE_SENDERINITIALS				@"senderInitials"		//	String
#define		FMESSAGE_SENDERPICTURE				@"senderPicture"		//	String

#define		FMESSAGE_RECIPIENTID				@"recipientId"			//	String
#define		FMESSAGE_RECIPIENTNAME				@"recipientName"		//	String
#define		FMESSAGE_RECIPIENTINITIALS			@"recipientInitials"	//	String
#define		FMESSAGE_RECIPIENTPICTURE			@"recipientPicture"		//	String

#define		FMESSAGE_GROUPID					@"groupId"				//	String
#define		FMESSAGE_GROUPNAME					@"groupName"			//	String
#define		FMESSAGE_GROUPPICTURE				@"groupPicture"			//	String

#define		FMESSAGE_TYPE						@"type"					//	String
#define		FMESSAGE_TEXT						@"text"					//	String

#define		FMESSAGE_PICTURE					@"picture"				//	String
#define		FMESSAGE_PICTURE_WIDTH				@"picture_width"		//	Number
#define		FMESSAGE_PICTURE_HEIGHT				@"picture_height"		//	Number
#define		FMESSAGE_PICTURE_MD5				@"picture_md5"			//	String

#define		FMESSAGE_VIDEO						@"video"				//	String
#define		FMESSAGE_VIDEO_DURATION				@"video_duration"		//	Number
#define		FMESSAGE_VIDEO_MD5					@"video_md5"			//	String

#define		FMESSAGE_AUDIO						@"audio"				//	String
#define		FMESSAGE_AUDIO_DURATION				@"audio_duration"		//	Number
#define		FMESSAGE_AUDIO_MD5					@"audio_md5"			//	String

#define		FMESSAGE_LATITUDE					@"latitude"				//	Number
#define		FMESSAGE_LONGITUDE					@"longitude"			//	Number

#define		FMESSAGE_STATUS						@"status"				//	String
#define		FMESSAGE_ISDELETED					@"isDeleted"			//	Boolean

#define		FMESSAGE_CREATEDAT					@"createdAt"			//	Timestamp
#define		FMESSAGE_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FLASTREAD_PATH						@"LastRead"				//	Path name
#define		FMUTEDUNTIL_PATH					@"MutedUntil"			//	Path name
//---------------------------------------------------------------------------------
#define		FSTATUS_PATH						@"Status"				//	Path name
#define		FSTATUS_OBJECTID					@"objectId"				//	String

#define		FSTATUS_CHATID						@"chatId"				//	String
#define		FSTATUS_LASTREAD					@"lastRead"				//	Timestamp
#define		FSTATUS_MUTEDUNTIL					@"mutedUntil"			//	Timestamp

#define		FSTATUS_CREATEDAT					@"createdAt"			//	Timestamp
#define		FSTATUS_UPDATEDAT					@"updatedAt"			//	Timestamp
//---------------------------------------------------------------------------------
#define		FTYPING_PATH						@"Typing"				//	Path name
//---------------------------------------------------------------------------------
#define		FUSERSTATUS_PATH					@"UserStatus"			//	Path name
#define		FUSERSTATUS_OBJECTID				@"objectId"				//	String

#define		FUSERSTATUS_NAME					@"name"					//	String

#define		FUSERSTATUS_CREATEDAT				@"createdAt"			//	Timestamp
#define		FUSERSTATUS_UPDATEDAT				@"updatedAt"			//	Timestamp
//-------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		ONESIGNALID							@"OneSignalId"
#define		USER_ACCOUNTS						@"UserAccounts"
#define		REACHABILITY_CHANGED				@"ReachabilityChanged"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NotificationAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NotificationUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NotificationUserLoggedOut"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_REFRESH_BLOCKEDS		@"NotificationRefreshBlockeds"
#define		NOTIFICATION_REFRESH_CALLHISTORIES	@"NotificationRefreshCallHistories"
#define		NOTIFICATION_REFRESH_CHATS			@"NotificationRefreshChats"
#define		NOTIFICATION_REFRESH_CONTACTS		@"NotificationRefreshContacts"
#define		NOTIFICATION_REFRESH_GROUPS			@"NotificationRefreshGroups"
#define		NOTIFICATION_REFRESH_MESSAGES1		@"NotificationRefreshMessages1"
#define		NOTIFICATION_REFRESH_MESSAGES2		@"NotificationRefreshMessages2"
#define		NOTIFICATION_REFRESH_STATUSES		@"NotificationRefreshStatuses"
#define		NOTIFICATION_REFRESH_USERS			@"NotificationRefreshUsers"
//---------------------------------------------------------------------------------
#define		NOTIFICATION_CLEANUP_CHATVIEW		@"NotificationCleanupChatView"
//-------------------------------------------------------------------------------------------------------------------------------------------------
#endif
