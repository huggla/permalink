ARG TAG="20181113-edge"
ARG BUILDDEPS="wget ssl_client"
ARG BUILDCMDS=\
"   mkdir /permalink "\
"&& wget -O /permalink/permalink.py https://raw.githubusercontent.com/sourcepole/qwc2-server/master/permalink.py "\
"&& sed -i '/CORS/d' /permalink/permalink.py "\
"&& pip3 install flask gunicorn"
ARG RUNDEPS="python3"
ARG EXECUTABLES="/usr/bin/python3"

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
