# Dockerfile development version
FROM ruby:3.1.2-alpine AS connect-development

# Install yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apk update \
    && apk upgrade \
    && apk add curl-dev nodejs yarn build-base postgresql-dev tzdata

# Default directory
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

# Install gems
WORKDIR $INSTALL_PATH
COPY connectfield/ .
RUN rm -rf node_modules vendor
RUN gem install rails bundler
RUN bundle install --path=vendor/bundle && gem install pg -v 1.1
RUN yarn install

# Start server
CMD ["rails", "server", "-b", "0.0.0.0"]