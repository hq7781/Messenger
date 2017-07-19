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

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MessagesView : RCMessagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------

@property (assign, nonatomic) long long lastRead;
@property (assign, nonatomic) NSInteger insertCounter;

@property (strong, nonatomic) RLMResults *dbmessages;
@property (strong, nonatomic) NSMutableDictionary *rcmessages;

@property (strong, nonatomic) NSMutableDictionary *avatarInitials;
@property (strong, nonatomic) NSMutableDictionary *avatarImages;
@property (strong, nonatomic) NSMutableArray *avatarIds;

- (void)loadMessages:(NSString *)groupId;

- (DBMessage *)dbmessage:(NSIndexPath *)indexPath;

- (RCMessage *)rcmessage:(NSIndexPath *)indexPath;

@end
