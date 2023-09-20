FROM  mcr.microsoft.com/devcontainers/base:jammy

#事前準備
RUN apt update -y
RUN apt upgrade -y

#開発ツールのインストール
RUN apt install git python3 python3-pip gcc build-essential curl pkg-config libudev-dev libtinfo5 -y
RUN apt install llvm-dev libclang-dev clang -y

ARG username=vscode
RUN  echo "%${username}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${username} && chmod 0440 /etc/sudoers.d/${username} 

USER ${username}
CMD ["bash"]

WORKDIR /home/${username}

#rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

#ENV RUSTUP_HOME ${CARGO_HOME}/bin

##COPY $HOME/.rustup/rustup.sh ${RUST_HOME}/rustup.sh

##RUN chmod +x ${RUSTUP_HOME}/rustup.sh

ENV PATH="./.cargo/bin:$PATH"
#ENV PATH $PATH:$CARGO_HOME/bin
#CMD source "$HOME/.cargo/env"

#ENV CARGO_HOME $HOME./.cargo
#ENV RUSTUP_HOME ${CARGO_HOME}/bin

#RUN ls ${RUSTUP_HOME}

#RUN echo $PATH
#RUN echo ${RUSTUP_HOME}

#rust toolchainのインストール
RUN rustup toolchain install nightly
RUN rustup component add rust-src --toolchain nightly-aarch64-unknown-linux-gnu
RUN rustup default nightly-aarch64-unknown-linux-gnu

#関連ツールのインストール
RUN cargo install ldproxy

#ESP開発環境のインストール
RUN cargo install cargo-espflash
RUN cargo install espup
RUN espup install
RUN sudo ldconfig

RUN cargo install cargo-generate
 
#PATHの設定
RUN echo '. "./.cargo/env"' >> ./.bashrc
RUN cat ./export-esp.sh >> ./.bashrc

#RUN source $HOME/.bashrc
