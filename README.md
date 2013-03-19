FBShare-iOS-Cocos2d-X
=====================

Facebook share for cocos2d-x iOS. Using Facebook SDK 3.0. 

This implementation only handled facebook share and tightly coupled with cocos2d-x for
callback. Should be fine with 1.x and 2.x version.

## Setup

There are a lot of things to setup. Refer back to Facebook SDK documentation for the 
usual stuffs (FacebookAppID, which framework to add).

We also need to add a few handler in AppController.mm first using FacebookShare_objc. See 
source on References folder.

1. Add openURL method and make FacebookShare handle it.
2. Add FacebookShare handleDidBecomeActive on applicationDidBecomeActive method.
3. Add FacebookShare closeSession on applicationWillTerminate.

## Usage

Callback is using CallFunc selector on cocos2d-x, which makes the share function can only
be called from all object that inherit from CCNode. Also, always check the response whether
the share feedback (login and posting) is successful or not.

### Example Open Session

```
if (!FacebookShare::sharedFacebookShare().isSessionOpen())
{
    FacebookShare::sharedFacebookShare().createSession();
    FacebookShare::sharedFacebookShare().openSession(this, callfunc_selector(EndScene::facebookLoginCallback));
}
```

### Example Posting

```
FacebookShare::sharedFacebookShare().post(post, this, callfunc_selector(EndScene::facebookPostCallback));
```
