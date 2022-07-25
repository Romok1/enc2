FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Define versions
ENV NVM_VERSION=0.33.11
ENV NODE_VERSION=12.9.1
ARG BUNDLER_VERSION=2.3.18

ENV BUNDLER_VERSION=${BUNDLER_VERSION}

# Install NVM
# Install nvm with node and npm
#ENV NVM_DIR /usr/local/nvm
ENV NVM_DIR=/root/.nvm
RUN mkdir -p $NVM_DIR
RUN /bin/bash -l -c "curl -L https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash  && source $NVM_DIR/nvm.sh"
#RUN /bin/bash -l -c ". $HOME/.nvm/nvm.sh \
RUN /bin/bash -l -c "source $NVM_DIR/nvm.sh \
                    && nvm install $NODE_VERSION \
                    && nvm alias default $NODE_VERSION \
                    && nvm use default \
                    && npm install -g yarn && npm g puppeteer"

#Use npm to install yarn
#RUN npm install -g yarn \
#     && npm g puppeteer

# Export NODE_PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules

# Update PATH to make node/npm accessible
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm -v

RUN gem install bundler -v ${BUNDLER_VERSION} --no-document
RUN mkdir /enc2
WORKDIR /enc2
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
#RUN bundle _${BUNDLER_VERSION}_ install -j 4
RUN bundle install -j 4

COPY package*.json yarn.lock ./
RUN yarn install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
 
ADD . /enc2
WORKDIR /enc2

CMD ["rails","server","-b","0.0.0.0"]
