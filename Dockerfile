FROM alpine:3.24.1

# Create a non-root user and group first
# -S creates a system user/group, which is standard for apps
RUN addgroup -S appgroup \
    && adduser -S appuser -G appgroup


RUN apk add --no-cache \
    bash \
    curl \
    jq 

WORKDIR /app

# Create the response folder and give the non-root user ownership of the /app directory
RUN mkdir -p /app/responses \
    && chown -R appuser:appgroup /app

# Copy your scripts into the container
# Use --chown so the files belog to appuser, not root
COPY --chown=appsuser:appgroup  . /app

# Switch away from root. Everything below this line runs as appuser
USER appuser

CMD [ "bash", "start_chat.sh" ]   