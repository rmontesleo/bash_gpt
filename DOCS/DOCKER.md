
### Docker operations
```bash

# pull ubuntu image
docker pull ubuntu:22.04

# In may 2025 is Ubuntu 25.10
docker pull ubuntu:devel

#build docker image
docker build -t bashgpt:1 .

# Running container
docker run -d --name bashgpt bashgpt:1

# Pass environment variables in argument
docker run -d -e OPENAI_API_KEY=$OPENAI_API_KEY bashgpt:1

# Pass all required env varialbes by .env file and flag
docker run -d --env-file=.env -e OPENAI_API_KEY=$OPENAI_API_KEY  bashgpt:1

```

### Basic Docker commands
```bash
# list all containers
docker ps -a

# list only the containers id
docker ps -aq

# Force to delete all containers (running or not)
docker rm -f $(docker ps -aq)

```


## REFERENCES
- [Writing a Dockerfile](https://docs.docker.com/get-started/docker-concepts/building-images/writing-a-dockerfile/)
- [Set environment variables within your container's environment](https://docs.docker.com/compose/how-tos/environment-variables/set-environment-variables/)
- [Set environment variables (-e, --env, --env-file)](https://docs.docker.com/reference/cli/docker/container/run/#env)
- []()
- []()

## SOLVING ISSUES
- [How do I pass environment variables to Docker containers?](https://stackoverflow.com/questions/30494050/how-do-i-pass-environment-variables-to-docker-containers)