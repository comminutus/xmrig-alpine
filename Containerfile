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

FROM alpine:${alpine_tag} as base


########################################################################################################################
# Build Image
########################################################################################################################
FROM base as build
ARG build_dir repo repo_tag

WORKDIR $build_dir

# Update base Alpine system and add build packages
RUN apk update
ARG build_packages='autoconf automake cmake g++ git hwloc-dev libtool libuv-dev make openssl-dev'
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

# Build MSR mod
WORKDIR $build_dir
RUN git clone https://github.com/intel/msr-tools.git
WORKDIR $build_dir/msr-tools
RUN ./autogen.sh
RUN make

########################################################################################################################
# Final Image
########################################################################################################################
FROM base as final
ARG arg_additional build_dir install_dir

WORKDIR /root

# Upgrade pre-installed Alpine packages and install runtime dependencies
RUN apk --no-cache upgrade
ARG runtime_packages='hwloc libuv'
RUN apk add --no-cache $runtime_packages

# Install binaries
COPY --from=build $build_dir/source/xmrig                       $install_dir
COPY --from=build $build_dir/source/scripts/randomx_boost.sh    /root
COPY --from=build $build_dir/source/src/config.json             /root/.config/xmrig.json
COPY --from=build $build_dir/msr-tools/wrmsr                    /usr/local/bin

# Environment variables, overridable from container
ENV XMRIG_ADDITIONAL_ARGS=$arg_additional
ENV XMRIG_CONFIG=
ENV XMRIG_CPU_AFFINITY=
ENV XMRIG_CPU_PRIORITY=
ENV XMRIG_PROXY=
ENV XMRIG_URL=
ENV XMRIG_THREADS=

# Copy container entrypoint script into container
COPY entrypoint.sh .

# Run entrypoint script
ENTRYPOINT ["./entrypoint.sh"]