ARG TAG="20181204"
ARG CONTENTIMAGE1="huggla/pyinstaller-alpine:$TAG"
ARG CONTENTDESTINATION1="/"
ARG BUILDCMDS=\
"   head -62 /buildfs/src/permalink.py.org > /src/permalink.py "\
"&& sed -i '/CORS/d' /src/permalink.py "\
"&& tail -26 /buildfs/src/permalink.py.add >> /src/permalink.py "\
"&& sed -i 's/# Copyright 2018, Sourcepole AG/# Copyright 2018, Sourcepole AG, Henrik Uggla/' /src/permalink.py "\
"&& cp /buildfs/src/requirements.txt /src/ "\
"&& cd /src "\
"&& /pyinstaller/pyinstaller.sh --noconfirm --clean --exclude-module Werkzeug --distpath /imagefs permalink.py "\
"&& chmod ug=rx,o= /imagefs/permalink "\
"&& cd /imagefs/usr/local/bin "\
"&& ln -s ../../../permalink/permalink permalink"
ARG REMOVEFILES="/sbin /usr/include /usr/share /usr/sbin" 

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
COPY --from=build /imagefs /
#-----------------------------------------

RUN chmod go= /bin/* \
 && chmod g=rx /bin

ENV VAR_LINUX_USER="plink" \
    VAR_GUNICORN_PARAMS="bind=0.0.0.0:8080" \
    VAR_FINAL_COMMAND="permalink \$VAR_GUNICORN_PARAMS"

#---------------Don't edit----------------
USER starter
ONBUILD USER root
#-----------------------------------------
