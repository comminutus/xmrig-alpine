# xmrig-alpine
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](https://www.gnu.org/licenses/agpl-3.0.html)
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
| `XMRIG_PROXY`         | `--proxy`         |
| `XMRIG_URL`           | `--url`           |
| `XMRIG_THREADS`       | `--threads`       |

If there are other options you'd like to set that don't correspond to an environment variable, you can provide them by setting `XMRIG_ADDITIONAL_ARGS` to include other arguments.  For example: `XMRIG_ADDITIONAL_ARGS=--user=foo --pass=bar`.

Not all options are available through command line arguments, so you may want to provide a [configuration file](https://xmrig.com/docs/miner/command-line-options) by setting the `XMRIG_CONFIG` environment variable.

### User/Group
The container runs as `root` in order to take advantage of any hardware performance enhancements, such as utilizing the MSR mod. Note this requires the host user also be `root`.

## Common Issues
- `FAILED TO APPLY MSR MOD, HASHRATE WILL BE LOW`
    In order to take advantage of the MSR MOD, you must use a _rootful_ (i.e. `root` user) _privileged_ container (`sudo podman run --privileged`, etc.)

## Dependencies
| Name                                         | Version   |
| -------------------------------------------- | --------- |
| [Alpine Linux](https://www.alpinelinux.org/) | v3.19.1   |
| [xmrig](https://github.com/xmrig/xmrig)      | v6.21.10  |


## License
This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

This container image includes a compiled [xmrig](https://github.com/xmrig/xmrig) binary, which is distributed under
the terms of the GNU General Public License version 3 (GPLv3). The corresponding source code can be obtained
[here](https://github.com/xmrig/xmrig).
