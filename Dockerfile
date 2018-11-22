ARG TAG="20181122"
ARG RUNDEPS="python2"
ARG DOWNLOADSDIR="/permalink"
ARG DOWNLOADS="https://raw.githubusercontent.com/sourcepole/qwc2-server/master/permalink.py"
ARG BUILDDEPS="py2-pip"
ARG BUILDCMDS=\
"   sed -i '/CORS/d' /imagefs$DOWNLOADSDIR/permalink.py "\
"&& python2.7 -OO -m compileall /imagefs$DOWNLOADSDIR "\
"&& pip2 install --no-cache-dir --upgrade pip "\
"&& pip2 install --no-cache-dir --root /imagefs flask gunicorn "\
"&& cp -a /usr/lib/python2.7/site-packages/pkg_resources /imagefs/usr/lib/python2.7/site-packages/ "\
"&& find /usr/bin/* -type f -delete "\
"&& find /imagefs/usr/lib/python2.7/site-packages/* -name \"*.py\" -delete "\
"&& sed -i 's|#!/usr/bin/python2|#!/usr/local/bin/python2.7|' /imagefs/usr/bin/gunicorn"
ARG EXECUTABLES="/usr/bin/python2.7 /usr/bin/gunicorn"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base:$TAG} as base
FROM huggla/build:$TAG as build
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
