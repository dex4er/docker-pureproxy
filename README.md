# pureproxy

[![GitHub](https://img.shields.io/github/last-commit/dex4er/docker-pureproxy/main?logo=github&label=GitHub)](https://github.com/dex4er/docker-pureproxy)
[![CI](https://github.com/dex4er/docker-pureproxy/actions/workflows/ci.yaml/badge.svg)](https://github.com/dex4er/docker-pureproxy/actions/workflows/ci.yaml)
[![Trunk Check](https://github.com/dex4er/docker-pureproxy/actions/workflows/trunk.yaml/badge.svg)](https://github.com/dex4er/docker-pureproxy/actions/workflows/trunk.yaml)
[![Docker Image Version](https://img.shields.io/docker/v/dex4er/pureproxy/latest?label=docker&logo=docker)](https://hub.docker.com/r/dex4er/pureproxy)
[![Amazon ECR Image Version](https://img.shields.io/docker/v/dex4er/pureproxy?label=Amazon%20ECR&logo=Amazon+AWS)](https://gallery.ecr.aws/dex4er/pureproxy)

Container image with
[PureProxy](https://metacpan.org/pod/pureproxy)
HTTP proxy server.

## Tags

- `X.Y.Z-alpine-X.Y.Z-perl-X.Y.Z-rN-PLATFORM`, `X.Y.Z-alpine-X.Y.Z-perl-X.Y.Z-rN`, `X.Y.Z`, `latest`.

## Usage

CLI:

```shell
docker pull dex4er/pureproxy
docker run -p 5000:5000 dex4er/pureproxy
```

## License

[License information](https://metacpan.org/release/DEXTER/App-PureProxy-0.0200/source/LICENSE) for
[PureProxy](https://metacpan.org/pod/pureproxy) project.

[License
information](https://github.com/dex4er/docker-pureproxy/blob/main/LICENSE) for
container image project.
