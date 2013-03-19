#ifndef __FACEBOOK_SHARE_OBJC_H__
#define __FACEBOOK_SHARE_OBJC_H__

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookShare_objc : NSObject

//Facebook sdk session
@property (strong, nonatomic) FBSession *session;

//Session
- (void) createSession;
- (void) openSession;
- (void) sessionStateChanged:(FBSession*)session state:(FBSessionState)state error:(NSError*)error;
- (void) closeSession;
- (void) closeSessionAndClearTokenInformation;
- (BOOL) isSessionOpen;

//Handler
- (BOOL) handleOpenURL:(NSURL*)url;
- (void) handleDidBecomeActive;

//Post
- (void) post:(NSString*)text;
- (void) postCallback;

//Singleton instance
+ (FacebookShare_objc *)sharedFacebookShare;

@end

#endif
