FROM ubuntu:devel

RUN apt-get update && apt-get install -y jq

WORKDIR /app
COPY . /app

CMD [ "bash", "start_chat.bash" ]