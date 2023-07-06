# **********************************************************
# * Note: Using a Dockerfile is optional when using Docker *
# * Compose but has been included here for completeness.   *
# **********************************************************
FROM elixir:1.15.1-alpine

# This Dockerfile adds a non-root user with sudo access. Use the “remoteUser” property in
# devcontainer.json to use it. More info: https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common setup script
ARG INSTALL_ZSH="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-alpine.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apk update \
  && apk add --no-cache curl ca-certificates \
  && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
  && if [ "$COMMON_SCRIPT_SHA" != "dev-mode" ]; then echo "$COMMON_SCRIPT_SHA */tmp/common-setup.sh" | sha256sum -c - ; fi \
  && /bin/ash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
  && rm /tmp/common-setup.sh

ENV MIX_ENV="dev"

RUN apk update && \
    apk add --upgrade --no-cache alpine-sdk && \
    apk add --upgrade --no-cache npm && \
    apk add --upgrade --no-cache inotify-tools && \
    apk add --upgrade --no-cache bash && \
    apk add --upgrade --no-cache openrc && \
    apk add --upgrade --no-cache openssh && \ 
    rc-update add sshd && \
    mix local.hex --force && \
    mix archive.install hex phx_new ${PHX_VERSION} --force && \
    mix local.rebar --force

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000
