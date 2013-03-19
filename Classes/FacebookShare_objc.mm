#import "FacebookShare_objc.h"
#import "FacebookShare.h"

@implementation FacebookShare_objc

@synthesize session = _session;

//Session
- (void) createSession
{
    //Create
    self.session = [[FBSession alloc] init];
    
    //Set in case needed
    [FBSession setActiveSession:self.session];
}

- (void) openSession
{
    //Open session
    [self.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
        //Call completion handler
        [self sessionStateChanged:session state:status error:error];
    }];
}

- (void) sessionStateChanged:(FBSession*)session state:(FBSessionState)state error:(NSError*)error
{
    //Handle according sessions tate
    int newState = FacebookShare::SESSION_STATE_CLOSED;
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                NSLog(@"User session found");
                newState = FacebookShare::SESSION_STATE_OPEN;
            }
            break;
        case FBSessionStateOpenTokenExtended:
            newState = FacebookShare::SESSION_STATE_OPENTOKENEXTENDED;
            break;
        case FBSessionStateClosed:
            newState = FacebookShare::SESSION_STATE_CLOSED;
            break;
        case FBSessionStateClosedLoginFailed:
            newState = FacebookShare::SESSION_STATE_CLOSEDLOGINFAILED;
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    //Set new state
    FacebookShare::sharedFacebookShare().setSessionState(newState);
    
    //Call callback
    FacebookShare::sharedFacebookShare().openSessionCallback();
    
    //Show error if needed
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) closeSession
{
    [self.session close];
}

- (void) closeSessionAndClearTokenInformation
{
    [self.session closeAndClearTokenInformation];
}

- (BOOL) isSessionOpen
{
    return self.session.isOpen;
}

//Handler
- (BOOL)handleOpenURL:(NSURL*)url
{
    return [self.session handleOpenURL:url];
}

- (void)handleDidBecomeActive
{
    return [self.session handleDidBecomeActive];
}

//Post
- (void) post:(NSString*)text
{
    FacebookShare::sharedFacebookShare().setIsPostSuccess(false);
    [self performPublishAction:^{
        [FBRequestConnection startForPostStatusUpdate:text
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
        {
            if (!error)
            {
                FacebookShare::sharedFacebookShare().setIsPostSuccess(true);
            }
            [self postCallback];
        }];
    }];
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([self.session.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [self.session reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                 }];
    } else {
        action();
    }
    
}

- (void) postCallback
{
    //Call callback
    FacebookShare::sharedFacebookShare().postCallback();
}

//Singleton instance
+ (FacebookShare_objc *)sharedFacebookShare
{
    static FacebookShare_objc *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[FacebookShare_objc alloc] init];
            sharedSingleton.session = [[FBSession alloc] init];
        }
        
        return sharedSingleton;
    }
}

@end
