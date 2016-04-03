FROM golang:1.4.2

WORKDIR /root 

RUN apt-get update
RUN apt-get --assume-yes install git
RUN apt-get --assume-yes install python2.7
RUN apt-get --assume-yes install curl
RUN apt-get --assume-yes install vim
RUN apt-get --assume-yes install postgresql-client

RUN go get github.com/mattes/migrate

RUN git config --global user.email "???"
RUN git config --global user.name "???"

RUN mkdir .aws
COPY .aws .aws/

RUN mkdir .docker
COPY .docker .docker/

RUN mkdir .ssh
COPY .ssh .ssh/
RUN chmod 600 .ssh/*

RUN eval "$(ssh-agent -s)" && ssh-add .ssh/id_rsa 

# Install AWS EB CLI
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python2.7 get-pip.py
RUN rm -f get-pip.py
RUN pip install awsebcli

RUN mkdir deploy
COPY server deploy/

WORKDIR /root/deploy/build
RUN git clone git@github.com:???/web.git

# This is because "eb deploy" wants it to be a git repo
WORKDIR /root/deploy/ca
RUN git init
RUN git add -A
RUN git commit -m "Init"
WORKDIR /root/deploy/nz
RUN git init
RUN git add -A
RUN git commit -m "Init"

RUN mkdir -p /go/src/github.com/???
RUN ln -s /root/deploy/build/web /go/src/github.com/???/web

# TODO: remove this once publishing is sorted and content is read from 
# Github instead of _content folder (see documentation for "web" project 
# for further details)
WORKDIR /root/deploy/build/web
RUN git clone git@github.com:???/content.git _content

WORKDIR /root/deploy
