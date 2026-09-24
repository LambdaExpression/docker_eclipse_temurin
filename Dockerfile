FROM eclipse-temurin:17-jre-jammy

ARG APT_MIRROR=http://mirrors.aliyun.com/ubuntu

RUN set -eux; \
    if [ -n "${APT_MIRROR}" ]; then \
      sed -i "s|http://archive.ubuntu.com/ubuntu|${APT_MIRROR}|g; s|http://security.ubuntu.com/ubuntu|${APT_MIRROR}|g" /etc/apt/sources.list; \
    fi; \
    printf '%s\n' \
      'Acquire::Retries "3";' \
      'Acquire::http::Timeout "20";' \
      'Acquire::https::Timeout "20";' \
      > /etc/apt/apt.conf.d/99ci-timeouts; \
    apt-get update; \
    # less/grep：进容器看日志用。基础镜像不保证自带，必须显式安装。
    apt-get install -y --no-install-recommends \
      curl ca-certificates postgresql-client \
      grep less \
      python3 python3-pip python3-venv; \
    python3 -m venv /opt/cad-dcm; \
    /opt/cad-dcm/bin/pip install --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple \
      open3sdcm numpy Pillow \
      || /opt/cad-dcm/bin/pip install --no-cache-dir open3sdcm numpy Pillow; \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip

