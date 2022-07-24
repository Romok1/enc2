FROM ubuntu:18.04
#FROM ruby:2.5.0
#FROM node:12.18.3
RUN apt-get update && apt-get install -y curl chromium-browser nano vim build-essential yarn libpq-dev gnupg git postgresql-client wget shared-mime-info libnss3-dev libgbm-dev libxslt-dev libxml2-dev
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Define versions
ENV NVM_VERSION=0.33.11
ENV NODE_VERSION=12.9.1
ARG RVM_VERSION=2.6.3
ARG BUNDLER_VERSION=2.3.18

ENV RVM_VERSION=${RVM_VERSION}
ENV BUNDLER_VERSION=${BUNDLER_VERSION}

ENV BUNDLE_PATH=vendor/bundle
# Install NVM
ENV NVM_DIR=/root/.nvm
RUN mkdir -p $NVM_DIR

#RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
#RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
        && source $NVM_DIR/nvm.sh

# Fetch and install nodejs via nvm
RUN source $NVM_DIR/nvm.sh \
      && nvm install $NODE_VERSION \
      && nvm alias default $NODE_VERSION \
      && nvm use default

# Export NODE_PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules

# Update PATH to make node/npm accessible
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#Use npm to install yarn
RUN npm install -g yarn
#RUN npm i puppeteer --unsafe-perm --ignore-scripts
RUN npm g puppeteer
#RUN yarn add puppeteer

# Install RVM, Ruby, and Bundler
RUN curl -sSL https://get.rvm.io | bash -s
SHELL ["/bin/bash", "-l", "-c"]
RUN rvm requirements && rvm install ${RVM_VERSION} \
          && rvm use ${RVM_VERSION} \
          && gem install bundler -v ${BUNDLER_VERSION} --no-document
RUN \touch .bashrc
RUN echo 'source /etc/profile.d/rvm.sh' > .bashrc
CMD source ~/.rvm/scripts/rvm
ENV PATH $PATH:/usr/local/rvm/bin
CMD ["/bin/bash", "-l", "-c", "source ~/.rvm/scripts/rvm"]

# Create a user and group
#RUN addgroup -S wcmc
#RUN adduser -S -D -h /enc2 wcmc wcmc

#RUN adduser --system --group --no-create-home wcmc
RUN adduser --system --group wcmc
RUN usermod -aG sudo wcmc
ENV APP /enc2-changeR
RUN mkdir $APP
WORKDIR $APP

COPY Gemfile Gemfile.lock $APP/
COPY package*.json yarn.lock $APP/ 
#./

COPY --chown=wcmc:wcmc . $APP

#RUN bundle config build.nokogiri --use-system-libraries --platform=ruby
#RUN bundle config set force_ruby_platform true
RUN gem install nokogiri --platform=ruby
RUN bundle check || bundle _${BUNDLER_VERSION}_ install

#COPY package*.json yarn.lock ./
#RUN npm rebuild node-sass
#RUN npm install node-sass -g

RUN yarn install 
#--frozen-lockfile

#ADD Gemfile* $APP
#RUN bundle update mimemagic
#RUN bundle _${BUNDLER_VERSION}_ install

#COPY --chown=wcmc:wcmc . $APP

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails","server","-b","0.0.0.0"]
