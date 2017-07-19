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

#import "ChatView.h"
#import "GroupView.h"
#import "ProfileView.h"
#import "CallAudioView.h"
#import "CallVideoView.h"
#import "PictureView.h"
#import "VideoView.h"
#import "MapView.h"
#import "StickersView.h"
#import "SelectMemberView.h"
#import "SelectUsersView.h"
#import "NavigationController.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ChatView()
{
	NSString *chatId;
	NSString *recipientId;
	NSString *groupId;

	BOOL isGroup;
	BOOL isPrivate;
	BOOL isBlocker;

	NSTimer *timer;

	NSInteger typingCounter;

	FIRDatabaseReference *firebase1;
	FIRDatabaseReference *firebase2;

	NSMutableArray *mentions;

	BOOL forwarding;
	NSArray *callButtons;
	UIBarButtonItem *buttonBack;
	UIBarButtonItem *buttonCallAudio;
	UIBarButtonItem *buttonCallVideo;
	UIBarButtonItem *buttonForwardCancel;
	UIBarButtonItem *buttonForwardSend;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ChatView

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSDictionary *)dictionary
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	chatId = dictionary[@"chatId"];
	recipientId = dictionary[@"recipientId"];
	groupId = dictionary[@"groupId"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	isPrivate = ([recipientId length] != 0);
	isGroup = ([groupId length] != 0);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	isBlocker = (isPrivate) ? [Blocked isBlocker:recipientId] : NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationController.interactivePopGestureRecognizer.delegate = self;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_back"] style:UIBarButtonItemStylePlain target:self
												 action:@selector(actionBack)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonCallAudio = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_callaudio"] style:UIBarButtonItemStylePlain target:self
													  action:@selector(actionCallAudio)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonCallVideo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_callvideo"] style:UIBarButtonItemStylePlain target:self
													  action:@selector(actionCallVideo)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonForwardCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
																		action:@selector(actionForwardCancel)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonForwardSend = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self
														action:@selector(actionForwardSend)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	callButtons = isPrivate ? @[buttonCallVideo, buttonCallAudio] : nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self updateForwardDetails:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([FUser wallpaper] != nil)
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[FUser wallpaper]]];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_CLEANUP_CHATVIEW];
	[NotificationCenter addObserver:self selector:@selector(refreshTableView1) name:NOTIFICATION_REFRESH_MESSAGES1];
	[NotificationCenter addObserver:self selector:@selector(refreshTableView2) name:NOTIFICATION_REFRESH_MESSAGES2];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	firebase1 = [[[FIRDatabase database] referenceWithPath:FTYPING_PATH] child:chatId];
	firebase2 = [[[FIRDatabase database] referenceWithPath:FLASTREAD_PATH] child:chatId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	mentions = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self loadMessages:chatId];
	[self refreshTableView2];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self typingIndicatorObserver];
	[self createLastReadObservers];
	//---------------------------------------------------------------------------------------------------------------------------------------------
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateTitleDetails) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Messages assignChatId:chatId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Status updateLastRead:chatId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self updateTitleDetails];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidDisappear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[timer invalidate]; timer = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([self isMovingFromParentViewController])
	{
		[self actionCleanup];
	}
}

#pragma mark - Forward details methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateForwardDetails:(BOOL)forwarding_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	forwarding = forwarding_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView setEditing:forwarding animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.leftBarButtonItem = forwarding ? buttonForwardCancel : buttonBack;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.rightBarButtonItems = forwarding ? @[buttonForwardSend] : callButtons;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.buttonTitle.userInteractionEnabled = (forwarding == NO);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.buttonInputAttach.userInteractionEnabled = (forwarding == NO);
	self.buttonInputSend.userInteractionEnabled = (forwarding == NO);
	self.textInput.userInteractionEnabled = (forwarding == NO);
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((forwarding == NO) && (isBlocker == YES))
	{
		self.navigationItem.rightBarButtonItems = nil;
		self.buttonInputAttach.userInteractionEnabled = NO;
		self.buttonInputSend.userInteractionEnabled = NO;
		self.textInput.userInteractionEnabled = NO;
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
}

#pragma mark - Title details methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateTitleDetails
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (isPrivate)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", recipientId];
		DBUser *dbuser = [[DBUser objectsWithPredicate:predicate] firstObject];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		self.labelTitle1.text = dbuser.fullname;
		self.labelTitle2.text = UserLastActive(dbuser);
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (isGroup)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", groupId];
		DBGroup *dbgroup = [[DBGroup objectsWithPredicate:predicate] firstObject];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		NSArray *members = [dbgroup.members componentsSeparatedByString:@","];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		self.labelTitle1.text = dbgroup.name;
		self.labelTitle2.text = [NSString stringWithFormat:@"%ld members", (long) [members count]];
	}
}

#pragma mark - Refresh methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)refreshTableView1
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self refreshTableView2];
	[self scrollToBottom:YES];
	[Status updateLastRead:chatId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)refreshTableView2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	BOOL show = self.insertCounter < [self.dbmessages count];
	[self loadEarlierShow:show];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView reloadData];
}

#pragma mark - Message send methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)messageSend:(NSString *)text picture:(UIImage *)picture video:(NSURL *)video audio:(NSString *)audio
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self typingIndicatorSave:@NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([Connection isReachable])
	{
		UIView *view = self.navigationController.view;
		[MessageSend1 send:chatId recipientId:recipientId groupId:groupId status:nil text:text picture:picture video:video audio:audio view:view];
	}
	else
	{
		AdvertPremium(self);
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (isPrivate) [Shortcut update:recipientId];
}

#pragma mark - Message delete methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)messageDelete:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBMessage *dbmessage = [self dbmessage:indexPath];
	[Message deleteItem:dbmessage];
}

#pragma mark - Last read methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)createLastReadObservers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[firebase2 observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
	{
		if (snapshot.exists)
		{
			NSDictionary *dictionary = snapshot.value;
			for (NSString *userId in [dictionary allKeys])
			{
				if ([userId isEqualToString:[FUser currentId]] == NO)
				{
					if ([dictionary[userId] longLongValue] > self.lastRead)
						self.lastRead = [dictionary[userId] longLongValue];
				}
			}
			[self.tableView reloadData];
		}
	}];
}

#pragma mark - Typing indicator methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorObserver
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[firebase1 observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot)
	{
		if ([snapshot.key isEqualToString:[FUser currentId]] == NO)
		{
			BOOL typing = [snapshot.value boolValue];
			[self typingIndicatorShow:typing animated:YES];
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorUpdate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	typingCounter++;
	[self typingIndicatorSave:@YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^{ [self typingIndicatorStop]; });
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorStop
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	typingCounter--;
	if (typingCounter == 0) [self typingIndicatorSave:@NO];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorSave:(NSNumber *)typing
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[firebase1 updateChildValues:@{[FUser currentId]:typing}];
}

#pragma mark - Menu controller methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSArray *)menuItems:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (forwarding) return nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	RCMenuItem *menuItemCopy = [[RCMenuItem alloc] initWithTitle:@"Copy" action:@selector(actionMenuCopy:)];
	RCMenuItem *menuItemSave = [[RCMenuItem alloc] initWithTitle:@"Save" action:@selector(actionMenuSave:)];
	RCMenuItem *menuItemDelete = [[RCMenuItem alloc] initWithTitle:@"Delete" action:@selector(actionMenuDelete:)];
	RCMenuItem *menuItemForward = [[RCMenuItem alloc] initWithTitle:@"Forward" action:@selector(actionMenuForward:)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	menuItemCopy.indexPath = indexPath;
	menuItemSave.indexPath = indexPath;
	menuItemDelete.indexPath = indexPath;
	menuItemForward.indexPath = indexPath;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSMutableArray *array = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_TEXT)		[array addObject:menuItemCopy];
	if (rcmessage.type == RC_TYPE_EMOJI)	[array addObject:menuItemCopy];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_PICTURE)	[array addObject:menuItemSave];
	if (rcmessage.type == RC_TYPE_VIDEO)	[array addObject:menuItemSave];
	if (rcmessage.type == RC_TYPE_AUDIO)	[array addObject:menuItemSave];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.outgoing)	[array addObject:menuItemDelete];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[array addObject:menuItemForward];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return array;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (action == @selector(actionMenuCopy:))		return YES;
	if (action == @selector(actionMenuSave:))		return YES;
	if (action == @selector(actionMenuDelete:))		return YES;
	if (action == @selector(actionMenuForward:))	return YES;
	return NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)canBecomeFirstResponder
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionBack
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.navigationController popViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTitle
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (isPrivate)
	{
		ProfileView *profileView = [[ProfileView alloc] initWith:recipientId Chat:NO];
		[self.navigationController pushViewController:profileView animated:YES];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (isGroup)
	{
		GroupView *groupView = [[GroupView alloc] initWith:groupId];
		[self.navigationController pushViewController:groupView animated:YES];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCallAudio
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	AdvertPremium(self);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCallVideo
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	AdvertPremium(self);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionAttachMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIAlertAction *alertCamera	 = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { PresentMultiCamera(self, YES); }];
	UIAlertAction *alertPicture	 = [UIAlertAction actionWithTitle:@"Picture" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { PresentPhotoLibrary(self, YES); }];
	UIAlertAction *alertVideo	 = [UIAlertAction actionWithTitle:@"Video" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { PresentVideoLibrary(self, YES); }];
	UIAlertAction *alertStickers = [UIAlertAction actionWithTitle:@"Sticker" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { [self actionStickers]; }];
	UIAlertAction *alertLocation = [UIAlertAction actionWithTitle:@"Location" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { [self actionLocation]; }];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[alertCamera setValue:[UIImage imageNamed:@"chat_camera"] forKey:@"image"];			[alert addAction:alertCamera];
	[alertPicture setValue:[UIImage imageNamed:@"chat_picture"] forKey:@"image"];		[alert addAction:alertPicture];
	[alertVideo setValue:[UIImage imageNamed:@"chat_video"] forKey:@"image"];			[alert addAction:alertVideo];
	[alertStickers setValue:[UIImage imageNamed:@"chat_sticker"] forKey:@"image"];		[alert addAction:alertStickers];
	[alertLocation setValue:[UIImage imageNamed:@"chat_location"] forKey:@"image"];		[alert addAction:alertLocation];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self presentViewController:alert animated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSendAudio:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self messageSend:nil picture:nil video:nil audio:path];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSendMessage:(NSString *)text
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self messageSend:text picture:nil video:nil audio:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSelectMember
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionStickers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	StickersView *stickersView = [[StickersView alloc] init];
	stickersView.delegate = self;
	NavigationController *navController = [[NavigationController alloc] initWithRootViewController:stickersView];
	[self presentViewController:navController animated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionLocation
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self messageSend:nil picture:nil video:nil audio:nil];
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSURL *video = info[UIImagePickerControllerMediaURL];
	UIImage *picture = info[UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self messageSend:nil picture:picture video:video audio:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SelectMemberDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectMember:(DBUser *)dbuser
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - StickersDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectSticker:(NSString *)sticker
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIImage *picture = [UIImage imageNamed:sticker];
	[self messageSend:nil picture:picture video:nil audio:nil];
}

#pragma mark - User actions (load earlier)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionLoadEarlier
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self.insertCounter += INSERT_MESSAGES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self refreshTableView2];
}

#pragma mark - User actions (bubble tap)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTapBubble:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (forwarding) return;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	DBMessage *dbmessage = [self dbmessage:indexPath];
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_STATUS)
	{

	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_PICTURE)
	{
		if (rcmessage.status == RC_STATUS_MANUAL)
		{
			[MediaLoader loadPictureManual:rcmessage dbmessage:dbmessage tableView:self.tableView];
			[self.tableView reloadData];
		}
		if (rcmessage.status == RC_STATUS_SUCCEED)
		{
			PictureView *pictureView = [[PictureView alloc] initWith:dbmessage.objectId chatId:chatId];
			[self presentViewController:pictureView animated:YES completion:nil];
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_VIDEO)
	{
		if (rcmessage.status == RC_STATUS_MANUAL)
		{
			[MediaLoader loadVideoManual:rcmessage dbmessage:dbmessage tableView:self.tableView];
			[self.tableView reloadData];
		}
		if (rcmessage.status == RC_STATUS_SUCCEED)
		{
			NSURL *url = [NSURL fileURLWithPath:rcmessage.video_path];
			VideoView *videoView = [[VideoView alloc] initWith:url];
			[self presentViewController:videoView animated:YES completion:nil];
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_AUDIO)
	{
		if (rcmessage.status == RC_STATUS_MANUAL)
		{
			[MediaLoader loadAudioManual:rcmessage dbmessage:dbmessage tableView:self.tableView];
			[self.tableView reloadData];
		}
		if (rcmessage.status == RC_STATUS_SUCCEED)
		{
			if (rcmessage.audio_status == RC_AUDIOSTATUS_STOPPED)
			{
				rcmessage.audio_status = RC_AUDIOSTATUS_PLAYING;
				[self.tableView reloadData];
				[[RCAudioPlayer sharedPlayer] playSound:rcmessage.audio_path completion:^{
					rcmessage.audio_status = RC_AUDIOSTATUS_STOPPED;
					[self.tableView reloadData];
				}];
			}
			else if (rcmessage.audio_status == RC_AUDIOSTATUS_PLAYING)
			{
				[[RCAudioPlayer sharedPlayer] stopSound:rcmessage.audio_path];
				rcmessage.audio_status = RC_AUDIOSTATUS_STOPPED;
				[self.tableView reloadData];
			}
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_LOCATION)
	{
		CLLocation *location = [[CLLocation alloc] initWithLatitude:rcmessage.latitude longitude:rcmessage.longitude];
		MapView *mapView = [[MapView alloc] initWith:location];
		NavigationController *navController = [[NavigationController alloc] initWithRootViewController:mapView];
		[self presentViewController:navController animated:YES completion:nil];
	}
}

#pragma mark - User actions (avatar tap)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTapAvatar:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (forwarding) return;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	DBMessage *dbmessage = [self dbmessage:indexPath];
	NSString *senderId = dbmessage.senderId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([senderId isEqualToString:[FUser currentId]] == NO)
	{
		ProfileView *profileView = [[ProfileView alloc] initWith:senderId Chat:NO];
		[self.navigationController pushViewController:profileView animated:YES];
	}
}

#pragma mark - User actions (menu)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionMenuCopy:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSIndexPath *indexPath = [RCMenuItem indexPath:sender];
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[[UIPasteboard generalPasteboard] setString:rcmessage.text];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionMenuSave:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSIndexPath *indexPath = [RCMenuItem indexPath:sender];
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_PICTURE)
	{
		if (rcmessage.status == RC_STATUS_SUCCEED)
			UIImageWriteToSavedPhotosAlbum(rcmessage.picture_image, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_VIDEO)
	{
		if (rcmessage.status == RC_STATUS_SUCCEED)
			UISaveVideoAtPathToSavedPhotosAlbum(rcmessage.video_path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_AUDIO)
	{
		if (rcmessage.status == RC_STATUS_SUCCEED)
		{
			NSString *path = [File temp:@"mp4"];
			[File copy:rcmessage.audio_path dest:path overwrite:YES];
			UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
		}
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionMenuDelete:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSIndexPath *indexPath = [RCMenuItem indexPath:sender];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self messageDelete:indexPath];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionMenuForward:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	AdvertCustom(self);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (error != nil)
		[ProgressHUD showError:@"Saving failed."];
	else [ProgressHUD showSuccess:@"Successfully saved."];
}

#pragma mark - User actions (forward)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionForwardCancel
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self updateForwardDetails:NO];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionForwardSend
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([self.tableView indexPathsForSelectedRows] == nil) return;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	SelectUsersView *selectUsersView = [[SelectUsersView alloc] init];
	selectUsersView.delegate = self;
	NavigationController *navController = [[NavigationController alloc] initWithRootViewController:selectUsersView];
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - SelectUsersDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectUsers:(NSMutableArray *)users groups:(NSMutableArray *)groups
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Cleanup methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[Messages resignChatId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[firebase1 removeAllObservers]; firebase1 = nil;
	[firebase2 removeAllObservers]; firebase2 = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter removeObserver:self];
}

@end
