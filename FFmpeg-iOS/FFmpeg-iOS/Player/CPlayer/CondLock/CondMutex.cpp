//
//  CondMutex.cpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/5.
//

#include "CondMutex.hpp"
CondMutex::CondMutex()
{
   // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    // 初始化锁
    pthread_mutex_init(&_pthreadMutex, &attr);
    pthread_mutexattr_destroy(&attr);
    // 初始化条件
    pthread_cond_init(&_cond, NULL);
}

CondMutex::~CondMutex() {
    pthread_mutex_destroy(&_pthreadMutex);
    pthread_cond_destroy(&_cond);
}


void CondMutex::lock() {
    pthread_mutex_lock(&_pthreadMutex);
}

int CondMutex::trylock() {
    return pthread_mutex_trylock(&_pthreadMutex);
}

void CondMutex::unlock() {
    pthread_mutex_unlock(&_pthreadMutex);
}

void CondMutex::signal() {
    pthread_cond_signal(&_cond);
}


void CondMutex::broadcast() {
    pthread_cond_broadcast(&_cond);
}

void CondMutex::wait() {
    pthread_cond_wait(&_cond, &_pthreadMutex);
}
