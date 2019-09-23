FROM ruby:2.6.3-stretch

ENV DEBCONF_NOWARNINGS yes
ENV TZ='Asia/Tokyo'
ENV LANG=C.UTF-8
ENV PORT=3000
ENV RAILS_ENV=production

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y build-essential nodejs yarn
RUN gem install bundler

RUN mkdir /lounge
WORKDIR /lounge
ADD Gemfile /lounge/Gemfile
ADD Gemfile.lock /lounge/Gemfile.lock
RUN bundle install --without development test
ADD . /lounge

RUN bundle exec rails assets:precompile
EXPOSE  3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
