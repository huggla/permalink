ARG TAG="20181113-edge"
ARG BUILDDEPS="ssl_client"
ARG BUILDCMDS=\
"   wget https://raw.githubusercontent.com/sourcepole/qwc2-server/master/permalink.py "\
"&& pip3 install flask flask_cors"
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
    VAR_FINAL_COMMAND="FLASK_APP=/permalink.py /usr/local/bin/python -m flask run -h "0.0.0.0" -p 8080"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
