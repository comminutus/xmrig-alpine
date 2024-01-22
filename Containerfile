########################################################################################################################
# Base Image
########################################################################################################################
# Core Config
ARG alpine_tag=3.19.0
ARG repo_tag=v6.21.0
ARG container_name=xmrig
ARG repo=https://github.com/xmrig/xmrig.git

# Defaults
ARG arg_additional=
ARG build_dir=/tmp/build
ARG install_dir=/usr/local/bin
ARG uid=10000
ARG user=$container_name

FROM alpine:${alpine_tag} as base


########################################################################################################################
# Build Image
########################################################################################################################
FROM base as build
ARG build_dir repo repo_tag

WORKDIR $build_dir

# Update base Alpine system and add build packages
RUN apk update
ARG build_packages='cmake g++ git hwloc-dev libuv-dev make openssl-dev'
RUN apk add $build_packages

# Download source
RUN git clone --recursive $repo source
WORKDIR $build_dir/source
RUN git checkout $repo_tag
RUN git submodule sync
RUN git submodule update --init --force

# Disable 1% donation
RUN sed -i 's/DonateLevel.*$/DonateLevel = 0;/g'                src/donate.h                        && \
    sed -i 's/"donate-level".*$/"donate-level": 0,/g'           src/config.json                     && \
    sed -i 's/"donate-over-proxy".*$/"donate-over-proxy": 0,/g' src/config.json                     && \
    sed -i 's/"donate-level".*$/"donate-level": 0,/g'           src/core/config/Config_default.h    && \
    sed -i 's/"donate-over-proxy".*$/"donate-over-proxy": 0,/g' src/core/config/Config_default.h

# Container specific build
RUN cmake .
RUN make -j$(nproc)


########################################################################################################################
# Final Image
########################################################################################################################
FROM base as final
ARG arg_additional build_dir install_dir uid user

WORKDIR /home/$user

# Upgrade pre-installed Alpine packages and install runtime dependencies
RUN apk --no-cache upgrade
ARG runtime_packages='hwloc libuv'
RUN apk add --no-cache $runtime_packages

# Install binaries
COPY --from=build $build_dir/source/xmrig            $install_dir
COPY --from=build $build_dir/source/src/config.json  /home/$user/.config/xmrig.json

# Environment variables, overridable from container
ENV XMRIG_ADDITIONAL_ARGS=$arg_additional
ENV XMRIG_CONFIG=
ENV XMRIG_CPU_AFFINITY=
ENV XMRIG_CPU_PRIORITY=
ENV XMRIG_URL=
ENV XMRIG_THREADS=

# Create user
RUN addgroup -g $uid -S $user && adduser -u $uid -S -D -G $user $user

# Copy container entrypoint script into container
COPY entrypoint.sh .

# Change ownership of all files in user dir and data dir
RUN chown -R $user:$user /home/$user

# Run as user
USER $user

# Run entrypoint script
ENTRYPOINT ["./entrypoint.sh"]