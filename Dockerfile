FROM eclipse-temurin:17-jre-jammy

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
      curl ca-certificates postgresql-client \
      grep less \
      python3 python3-pip python3-venv; \
    # 增加软链接，让pg_isready全局可用
    ln -s /usr/lib/postgresql/14/bin/pg_isready /usr/bin/pg_isready; \
    python3 -m venv /opt/cad-dcm; \
    /opt/cad-dcm/bin/pip install --no-cache-dir open3sdcm numpy Pillow; \
    rm -rf /var/lib/apt/lists/* /root/.cache/pip