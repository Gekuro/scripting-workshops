FROM ubuntu:latest

RUN apt update && apt install -y \
  build-essential \
  libssl-dev \
  lua5.4 \
  liblua5.4-dev \
  luarocks \
  curl \
  gnupg \
  apt-transport-https \
  software-properties-common

RUN curl -fsSL https://openresty.org/package/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/openresty.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | tee /etc/apt/sources.list.d/openresty.list \
    && apt update \
    && apt install -y openresty 

# TODO make rockspec file
RUN luarocks install lapis \
  && luarocks install pgmoon

WORKDIR /bubbles

RUN lapis new

COPY ./src .

EXPOSE 8080

CMD ["lapis", "server"]
