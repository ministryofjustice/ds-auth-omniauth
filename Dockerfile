FROM ministryofjustice/docker-moj-base:latest

##############################################################################
# Copy helper scripts into the container:
##############################################################################
# * clean-up-docker-container: Cleans up logs and other items that use space in the container.
ADD docker/bin/clean-up-docker-container /usr/local/bin/clean-up-docker-container

##############################################################################
# Apply Security Upgrades
##############################################################################
# **This always needs to be the very first step after installing the helper scripts.**
# If you 'date +%s > latest-security-upgrades' and commit it, the latest security updates
# will be appplied, because every later step will be invalidated
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ADD .latest-security-upgrades /.latest-security-upgrades
RUN apt-get update && apt-get -y upgrade && /usr/local/bin/clean-up-docker-container

# FIXME: Currently we're using brightbox's ruby 2.2.2 release, since we don't have
# a repo.dsd.io release of ruby 2.2.2. See story #93634238
# Instructions: https://www.brightbox.com/docs/ruby/ubuntu/
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" > /etc/apt/sources.list.d/brightbox-ruby-ng-trusty.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6 \
  && apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends git ruby2.2 ruby2.2-dev \
  && gem install bundler \
  && /usr/local/bin/clean-up-docker-container

##############################################################################
# Required Gems
##############################################################################
#
# By copying only the Gemfile and Gemfile.lock, we make this step cacheable,
# even if other items in the source directory have changed. See
# http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker/
# for more details.
#
ADD Gemfile /tmp/gemfile-when-docker-image-built/Gemfile
ADD Gemfile.lock /tmp/gemfile-when-docker-image-built/Gemfile.lock
ADD ds-auth-omniauth.gemspec /tmp/gemfile-when-docker-image-build/ds-auth-omniauth.gemspec
RUN bundle install --gemfile=/tmp/gemfile-when-docker-image-built/Gemfile && /usr/local/bin/clean-up-docker-container

###############################################################################
# Defaults for executing container
###############################################################################
ENV RAILS_ENV test
ENV RACK_ENV test
COPY . /usr/src/app
WORKDIR /usr/src/app

# Run specs by default
CMD ["bin/bundle", "exec", "rake", "--trace"]
