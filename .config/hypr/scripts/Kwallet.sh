#!/bin/sh

if test -n "$PAM_KWALLET5_LOGIN" ; then
    env | socat STDIN UNIX-CONNECT:$PAM_KWALLET5_LOGIN
fi
