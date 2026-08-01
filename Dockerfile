FROM alpine:3.24.1

RUN apk add --no-cache curl jq bash

WORKDIR /app
RUN mkdir responses
COPY . /app

CMD [ "bash", "start_chat.bash" ]