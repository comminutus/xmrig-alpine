# xmrig-alpine
[![License](https://img.shields.io/badge/License-GPL%203.0-blue.svg)](https://opensource.org/licenses/GPL-3.0)
[![CI](https://github.com/comminutus/xmrig-alpine/actions/workflows/ci.yaml/badge.svg)](https://github.com/comminutus/xmrig-alpine/actions/workflows/ci.yaml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/comminutus/xmrig-alpine)](https://github.com/comminutus/xmrig-alpine/releases/latest)


## Description
`xmrig-alpine` is a [xmrig](https://github.com/xmrig/xmrig) container image compiled for Alpine Linux.

## Getting Started
```
podman pull ghcr.io/comminutus/xmrig-alpine
podman run -it --rm ghcr.io/comminutus/xmrig-alpine
```

## Usage

### Environment Variables and Options
All configuration options from `xmrig` can be set directly via environment variables.  They correspond to the '`--`'
options that `xmrig` supports.  For help regarding a specific option, consult `xmrig --help`

**Supported Environment Variables:**

| Environment Variable  | `xmrig` Option    |
| --------------------- | ----------------- |
| `XMRIG_CONFIG`        | `--config`        |
| `XMRIG_CPU_AFFINITY`  | `--cpu-affinity`  |
| `XMRIG_CPU_PRIORITY`  | `--cpu-priority`  |
| `XMRIG_URL`           | `--url`           |
| `XMRIG_THREADS`       | `--threads`       |

If there are other options you'd like to set that don't correspond to an environment variable, you can provide them by setting `XMRIG_ADDITIONAL_ARGS` to include other arguments.  For example: `XMRIG_ADDITIONAL_ARGS=--user=foo --pass=bar`.

Not all options are available through command line arguments, so you may want to provide a [configuration file](https://xmrig.com/docs/miner/command-line-options) by setting the `XMRIG_CONFIG` environment variable.

### User/Group
The container uses a user named _xmrig_ with a UID of _10000_, with a group that matches the same.
If you'd like to change this, rebuild the container and set the `uid` build argument.

## License
This project inherits xmrig's GPL-3.0 license - see the [LICENSE](LICENSE) file for details.
