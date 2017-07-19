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

#import "DBMessage.h"
#import "DBUser.h"
#import "DBGroup.h"
#import "DBChat.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface Chat : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Update methods

+ (void)updateChat:(NSString *)chatId refreshUserInterface:(BOOL)refreshUserInterface;

#pragma mark - Delete, Archive methods

+ (void)deleteItem:(DBChat *)dbchat;
+ (void)archiveItem:(DBChat *)dbchat;
+ (void)unarchiveItem:(DBChat *)dbchat;

#pragma mark - ChatId methods

+ (NSString *)chatId:(NSArray *)members;

#pragma mark - Private Chat methods

+ (NSDictionary *)startPrivate:(DBUser *)dbuser2;

#pragma mark - Group Chat methods

+ (NSDictionary *)startGroup1:(FObject *)group;
+ (NSDictionary *)startGroup2:(DBGroup *)dbgroup;

#pragma mark - Restart Chat methods

+ (NSDictionary *)restartChat:(DBChat *)dbchat;

@end
