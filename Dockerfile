FROM ubuntu:focal

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --yes -- \
    software-properties-common \
    apt-transport-https \
    curl && \
    curl --location -- 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - && \
    add-apt-repository ppa:neovim-ppa/unstable

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --yes -- \
    neovim \
    git

COPY / /benchmark

WORKDIR /benchmark

RUN ./scripts/install.sh

VOLUME [ "/dump" ]

CMD ["scripts/ci.sh"]
