ARG TAG="20181113-edge"
ARG RUNDEPS="python2"
ARG DOWNLOADSDIR="/permalink"
ARG DOWNLOADS="https://raw.githubusercontent.com/sourcepole/qwc2-server/master/permalink.py"
ARG BUILDDEPS="py2-pip"
ARG BUILDCMDS=\
"   sed -i '/CORS/d' /imagefs$DOWNLOADSDIR/permalink.py "\
"&& cd /imagefs$DOWNLOADSDIR "\
"&& python2.7 -OO -m compileall "\
#"&& rm /imagefs$DOWNLOADSDIR/permalink.py "\
"&& pip2 install --no-cache-dir --upgrade pip "\
"&& pip2 install --no-cache-dir --ignore-installed --root /imagefs flask gunicorn "\
"&& cp -a /usr/lib/python2.7/site-packages/pkg_resources /imagefs/usr/lib/python2.7/site-packages/ "\
"&& cd /imagefs/usr/lib/python2.7/site-packages "\
"&& python2.7 -OO -m compileall "\
"&& sed -i 's|#!/usr/bin/python2|#!/usr/local/bin/python2.7|' /imagefs/usr/bin/gunicorn "\
"&& python2.7 -OO -m py_compile /imagefs/usr/bin/gunicorn"
ARG EXECUTABLES="/usr/bin/python2.7 /usr/bin/gunicornc /usr/bin/gunicorn"
ARG REMOVEFILES="" 

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base:$TAG} as base
FROM huggla/build:test as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

ENV VAR_LINUX_USER="python" \
    VAR_THREADS="1" \
    VAR_FINAL_COMMAND="\$gunicornCmdArgs gunicorn permalink:app"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
