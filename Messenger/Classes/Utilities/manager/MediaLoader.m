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

@implementation MediaLoader

#pragma mark - Picture public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPicture:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathImage:dbmessage.picture];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadPictureMedia:rcmessage dbmessage:dbmessage tableView:tableView];
	}
	else if (path != nil)
	{
		[self showPictureFile:rcmessage Path:path tableView:tableView];
	}
	else if (localIdentifier != nil)
	{
		[self loadPictureAlbum:rcmessage dbmessage:dbmessage tableView:tableView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureManual:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Picture private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadPictureMedia:rcmessage dbmessage:dbmessage tableView:tableView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadPictureMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager image:dbmessage.picture md5:dbmessage.picture_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path chatId:dbmessage.chatId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showPictureFile:rcmessage Path:path tableView:tableView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self savePictureAlbum:rcmessage dbmessage:dbmessage path:path];
		}
		else rcmessage.status = STATUS_MANUAL;
		[tableView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)savePictureAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage path:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showPictureImage:(RCMessage *)rcmessage Image:(UIImage *)image tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.picture_image = image;
	rcmessage.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[tableView reloadData];
	});
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showPictureFile:(RCMessage *)rcmessage Path:(NSString *)path tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.picture_image = [[UIImage alloc] initWithContentsOfFile:path];
	rcmessage.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[tableView reloadData];
	});
}

#pragma mark - Video public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideo:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathVideo:dbmessage.video];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadVideoMedia:rcmessage dbmessage:dbmessage tableView:tableView];
	}
	else if (path != nil)
	{
		[self showVideoFile:rcmessage Path:path tableView:tableView];
	}
	else if (localIdentifier != nil)
	{
		[self loadVideoAlbum:rcmessage dbmessage:dbmessage tableView:tableView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoManual:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Video private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadVideoMedia:rcmessage dbmessage:dbmessage tableView:tableView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadVideoMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager video:dbmessage.video md5:dbmessage.video_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path chatId:dbmessage.chatId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showVideoFile:rcmessage Path:path tableView:tableView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self saveVideoAlbum:rcmessage dbmessage:dbmessage path:path tableView:tableView];
		}
		else rcmessage.status = STATUS_MANUAL;
		[tableView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)saveVideoAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage path:(NSString *)path1 tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showVideoFile:(RCMessage *)rcmessage Path:(NSString *)path tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.video_path = path;
	UIImage *picture = [Video thumbnail:path];
	rcmessage.video_thumbnail = [Image square:picture size:320];
	rcmessage.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[tableView reloadData];
	});
}

#pragma mark - Audio public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudio:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathAudio:dbmessage.audio];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadAudioMedia:rcmessage dbmessage:dbmessage tableView:tableView];
	}
	else if (path != nil)
	{
		[self showAudioFile:rcmessage Path:path tableView:tableView];
	}
	else if (localIdentifier != nil)
	{
		[self loadAudioAlbum:rcmessage dbmessage:dbmessage tableView:tableView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioManual:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Audio private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadAudioMedia:rcmessage dbmessage:dbmessage tableView:tableView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadAudioMedia:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager audio:dbmessage.audio md5:dbmessage.audio_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path chatId:dbmessage.chatId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showAudioFile:rcmessage Path:path tableView:tableView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self saveAudioAlbum:rcmessage dbmessage:dbmessage path:path tableView:tableView];
		}
		else rcmessage.status = STATUS_MANUAL;
		[tableView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)saveAudioAlbum:(RCMessage *)rcmessage dbmessage:(DBMessage *)dbmessage path:(NSString *)path1 tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showAudioFile:(RCMessage *)rcmessage Path:(NSString *)path tableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	rcmessage.audio_path = path;
	rcmessage.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[tableView reloadData];
	});
}

@end
