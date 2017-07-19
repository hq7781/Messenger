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

#import "MessagesView.h"

@implementation MessagesView

@synthesize lastRead, insertCounter;
@synthesize dbmessages, rcmessages;
@synthesize avatarInitials, avatarImages, avatarIds;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	insertCounter = INSERT_MESSAGES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	rcmessages = [[NSMutableDictionary alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	avatarInitials = [[NSMutableDictionary alloc] init];
	avatarImages = [[NSMutableDictionary alloc] init];
	avatarIds = [[NSMutableArray alloc] init];
}

#pragma mark - Realm methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages:(NSString *)chatId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatId == %@ AND isDeleted == NO", chatId];
	dbmessages = [[DBMessage objectsWithPredicate:predicate] sortedResultsUsingKeyPath:FMESSAGE_CREATEDAT ascending:YES];
}

#pragma mark - DBMessage methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)index:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSInteger count = MIN(insertCounter, [dbmessages count]);
	NSInteger offset = [dbmessages count] - count;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return (indexPath.row + offset);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (DBMessage *)dbmessage:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSInteger index = [self index:indexPath];
	return dbmessages[index];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (DBMessage *)dbmessageAbove:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row > 0)
	{
		NSIndexPath *indexAbove = [NSIndexPath indexPathForItem:indexPath.row-1 inSection:0];
		return [self dbmessage:indexAbove];
	}
	return nil;
}

#pragma mark - Message methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (RCMessage *)rcmessage:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBMessage *dbmessage = [self dbmessage:indexPath];
	NSString *messageId = dbmessage.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessages[messageId] == nil)
	{
		RCMessage *rcmessage;
		//-----------------------------------------------------------------------------------------------------------------------------------------
		BOOL incoming = ([dbmessage.senderId isEqualToString:[FUser currentId]] == NO);
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_STATUS])
			rcmessage = [[RCMessage alloc] initWithStatus:dbmessage.text];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_TEXT])
			rcmessage = [[RCMessage alloc] initWithText:dbmessage.text incoming:incoming];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_EMOJI])
			rcmessage = [[RCMessage alloc] initWithEmoji:dbmessage.text incoming:incoming];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_PICTURE])
		{
			rcmessage = [[RCMessage alloc] initWithPicture:nil width:dbmessage.picture_width height:dbmessage.picture_height incoming:incoming];
			[MediaLoader loadPicture:rcmessage dbmessage:dbmessage tableView:self.tableView];
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_VIDEO])
		{
			rcmessage = [[RCMessage alloc] initWithVideo:nil durarion:dbmessage.video_duration incoming:incoming];
			[MediaLoader loadVideo:rcmessage dbmessage:dbmessage tableView:self.tableView];
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_AUDIO])
		{
			rcmessage = [[RCMessage alloc] initWithAudio:nil durarion:dbmessage.audio_duration incoming:incoming];
			[MediaLoader loadAudio:rcmessage dbmessage:dbmessage tableView:self.tableView];
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if ([dbmessage.type isEqualToString:MESSAGE_LOCATION])
		{
			rcmessage = [[RCMessage alloc] initWithLatitude:dbmessage.latitude longitude:dbmessage.longitude incoming:incoming completion:^{
				[self.tableView reloadData];
			}];
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		rcmessages[messageId] = rcmessage;
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return rcmessages[messageId];
}

#pragma mark - Avatar methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)avatarInitials:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBMessage *dbmessage = [self dbmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (avatarInitials[dbmessage.senderId] == nil)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", dbmessage.senderId];
		DBUser *dbuser = [[DBUser objectsWithPredicate:predicate] firstObject];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		avatarInitials[dbmessage.senderId] = [dbuser initials];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return avatarInitials[dbmessage.senderId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImage *)avatarImage:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBMessage *dbmessage = [self dbmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (avatarImages[dbmessage.senderId] == nil)
	{
		[self loadAvatarImage:dbmessage.senderId];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return avatarImages[dbmessage.senderId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadAvatarImage:(NSString *)userId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([avatarIds containsObject:userId]) return;
	else [avatarIds addObject:userId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", userId];
	DBUser *dbuser = [[DBUser objectsWithPredicate:predicate] firstObject];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager image:dbuser.thumbnail completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			avatarImages[userId] = [[UIImage alloc] initWithContentsOfFile:path];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.tableView reloadData];
			});
		}
		else if (error.code != 100) [avatarIds removeObject:userId];
	}];
}

#pragma mark - Header, Footer methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textCellHeader:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.row % 3 == 0)
	{
		DBMessage *dbmessage = [self dbmessage:indexPath];
		NSDate *date = [NSDate dateWithTimestamp:dbmessage.createdAt];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd MMMM, HH:mm"];
		return [dateFormatter stringFromDate:date];
	}
	else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textBubbleHeader:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [self rcmessage:indexPath];
	if (rcmessage.incoming)
	{
		DBMessage *dbmessage = [self dbmessage:indexPath];
		DBMessage *dbmessageAbove = [self dbmessageAbove:indexPath];
		if (dbmessageAbove != nil)
		{
			if ([dbmessage.senderId isEqualToString:dbmessageAbove.senderId])
				return nil;
		}
		return dbmessage.senderName;
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textBubbleFooter:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textCellFooter:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [self rcmessage:indexPath];
	if (rcmessage.outgoing)
	{
		DBMessage *dbmessage = [self dbmessage:indexPath];
		return (dbmessage.createdAt > lastRead) ? dbmessage.status : TEXT_READ;
	}
	return nil;
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return MIN(insertCounter, [dbmessages count]);
}

@end
