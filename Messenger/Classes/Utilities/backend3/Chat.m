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

#import "utilities.h"

@implementation Chat

#pragma mark - Update methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateChat:(NSString *)chatId refreshUserInterface:(BOOL)refreshUserInterface
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatId == %@ AND isDeleted == NO", chatId];
	DBMessage *dbmessage = [[[DBMessage objectsWithPredicate:predicate] sortedResultsUsingKeyPath:FMESSAGE_CREATEDAT ascending:YES] lastObject];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (dbmessage != nil)
	{
		[self updateItem:dbmessage];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (dbmessage == nil)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatId == %@", chatId];
		DBChat *dbchat = [[DBChat objectsWithPredicate:predicate] firstObject];
		[self deleteItem:dbchat];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (refreshUserInterface) [NotificationCenter post:NOTIFICATION_REFRESH_CHATS];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateItem:(DBMessage *)dbmessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBChat *dbchat = [[DBChat alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbchat.chatId = dbmessage.chatId;
	dbchat.members = dbmessage.members;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbchat.recipientId = @"";
	dbchat.groupId = @"";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbmessage.recipientId length] != 0)
	{
		if ([dbmessage.senderId isEqualToString:[FUser currentId]])
		{
			dbchat.recipientId = dbmessage.recipientId;
			dbchat.initials = dbmessage.recipientInitials;
			dbchat.picture = dbmessage.recipientPicture;
			dbchat.description = dbmessage.recipientName;
		}
		if ([dbmessage.recipientId isEqualToString:[FUser currentId]])
		{
			dbchat.recipientId = dbmessage.senderId;
			dbchat.initials = dbmessage.senderInitials;
			dbchat.picture = dbmessage.senderPicture;
			dbchat.description = dbmessage.senderName;
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbmessage.groupId length] != 0)
	{
		dbchat.groupId = dbmessage.groupId;
		dbchat.initials = @"";
		dbchat.picture = dbmessage.groupPicture;
		dbchat.description = dbmessage.groupName;
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbchat.lastMessage = dbmessage.text;
	dbchat.lastMessageDate = dbmessage.createdAt;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbchat.isArchived = NO;
	dbchat.isDeleted = NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbchat.createdAt = [[NSDate date] timestamp];
	dbchat.updatedAt = [[NSDate date] timestamp];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	[realm addOrUpdateObject:dbchat];
	[realm commitWriteTransaction];
}

#pragma mark - Delete, Archive methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)deleteItem:(DBChat *)dbchat
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	dbchat.isDeleted = YES;
	[realm commitWriteTransaction];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)archiveItem:(DBChat *)dbchat
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	dbchat.isArchived = YES;
	[realm commitWriteTransaction];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)unarchiveItem:(DBChat *)dbchat
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	dbchat.isArchived = NO;
	[realm commitWriteTransaction];
}

#pragma mark - ChatId methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)chatId:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSArray *sorted = [members sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	return [Checksum md5HashOfString:[sorted componentsJoinedByString:@""]];
}

#pragma mark - Private Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startPrivate:(DBUser *)dbuser2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *userId1 = [FUser currentId];
	NSString *userId2 = dbuser2.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSArray *members = @[userId1, userId2];
	NSString *chatId = [self chatId:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"chatId":chatId, @"recipientId":userId2, @"groupId":@""};
}

#pragma mark - Group Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startGroup1:(FObject *)group
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *groupId = [group objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *chatId = [Checksum md5HashOfString:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"chatId":chatId, @"recipientId":@"", @"groupId":groupId};
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startGroup2:(DBGroup *)dbgroup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *groupId = dbgroup.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *chatId = [Checksum md5HashOfString:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"chatId":chatId, @"recipientId":@"", @"groupId":groupId};
}

#pragma mark - Restart Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)restartChat:(DBChat *)dbchat
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return @{@"chatId":dbchat.chatId, @"recipientId":dbchat.recipientId, @"groupId":dbchat.groupId};
}

@end
