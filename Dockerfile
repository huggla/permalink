ARG TAG="20181113-edge"
ARG DOWNLOADSDIR="/permalink"
ARG DOWNLOADS="https://raw.githubusercontent.com/sourcepole/qwc2-server/master/permalink.py"
ARG BUILDDEPS="py2-pip"
ARG BUILDCMDS=\
"   sed -i '/CORS/d' /imagefs$DOWNLOADSDIR/permalink.py "\
"&& pip2 install flask gunicorn "\
"&& cp -a /usr/local/lib/python2.7/site-packages/* /imagefs/usr/local/lib/python2.7/site-packages/ "\
"&& cp -a /usr/bin/gunicorn /imagefs/usr/bin/gunicorn"
ARG RUNDEPS="python2"
ARG EXECUTABLES="/usr/bin/python2 /usr/bin/gunicorn"
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
