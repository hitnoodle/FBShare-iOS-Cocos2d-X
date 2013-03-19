#include "FacebookShare.h"
#include "FacebookShare_objc.h"

inline NSString* CStrToNSString(const char* string) {
    return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
}

FacebookShare::FacebookShare()
{
    isPostSucces = false;
}

FacebookShare::~FacebookShare()
{
    lTarget = NULL;
    lCallback = NULL;
    pTarget = NULL;
    pCallback = NULL;
}

//Session
void FacebookShare::createSession()
{
    [[FacebookShare_objc sharedFacebookShare] createSession];
}

void FacebookShare::openSession(cocos2d::CCObject* target, cocos2d::SEL_CallFunc callback)
{
    //Set callback
    this->lTarget = target;
    this->lCallback = callback;
    
    //Call
    [[FacebookShare_objc sharedFacebookShare] openSession];
}

void FacebookShare::openSessionCallback()
{
    if (lTarget && lCallback) (lTarget->*lCallback)();
}

void FacebookShare::closeSession()
{
    [[FacebookShare_objc sharedFacebookShare] closeSession];
}

void FacebookShare::closeSessionAndClearTokenInformation()
{
    [[FacebookShare_objc sharedFacebookShare] closeSessionAndClearTokenInformation];
}

bool FacebookShare::isSessionOpen()
{
    return [[FacebookShare_objc sharedFacebookShare] isSessionOpen];
}

void FacebookShare::setSessionState(int state)
{
    mSessionState = state;
}

int FacebookShare::getSessionState()
{
    return mSessionState;
}

//Method for posting
void FacebookShare::post(const char* text, cocos2d::CCObject* target, cocos2d::SEL_CallFunc callback)
{
    //Set callback
    this->pTarget = target;
    this->pCallback = callback;
    
    //Post
    [[FacebookShare_objc sharedFacebookShare] post:CStrToNSString(text)];
}

void FacebookShare::postCallback()
{
    if (pTarget && pCallback) (pTarget->*pCallback)();
}

void FacebookShare::setIsPostSuccess(bool success)
{
    isPostSucces = success;
}

bool FacebookShare::isPostSuccess()
{
    return isPostSucces;
}