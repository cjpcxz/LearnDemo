//
//  CondMutex.hpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/5.
//

#ifndef CondMutex_hpp
#define CondMutex_hpp

#include <stdio.h>
#include "pthread.h"
class CondMutex
{
public:
    CondMutex();
    ~CondMutex();
    void lock();
    int trylock();
    void unlock();
    void signal();
    void broadcast();
    void wait();
private:
    pthread_cond_t _cond;
    pthread_mutex_t _pthreadMutex;
};
#endif /* CondMutex_hpp */
