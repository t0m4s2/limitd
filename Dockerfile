FROM node:6

RUN apt-get update && apt-get install apt-transport-https && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

WORKDIR /app

EXPOSE 9231

ADD package.json yarn.lock /app/
RUN yarn

# Bundle app source
ADD . /app

RUN mkdir -p /var/limitd/database

# Don't use npm start to ensure it runs at PID=1
CMD ["./bin/limitd", "--config-file", "./conf/limitd.conf.example"]
