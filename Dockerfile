FROM alpine:3.12.7

RUN apk update
RUN apk upgrade

RUN apk add --no-cache moreutils bash wget curl docker-cli

RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.0/yq_linux_arm -O /usr/bin/yq
RUN chmod +x /usr/bin/yq

# The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD 
# instructions that follow it in the Dockerfile. If the WORKDIR doesn’t exist, it will be created
# even if it’s not used in any subsequent Dockerfile instruction.
WORKDIR /app

ADD app /app/

RUN chmod +x /app/wait-for-it.sh

CMD ["/bin/sh", "/app/monitorHA.sh"]