
## Docker commands to build and run image
```bash


#build docker image
image_name="bashgpt"
image_version="v1"
full_image_name="${image_name}:${image_version}"
docker build -t $full_image_name .

# Running container
# Pass required environment variables in argument
OPENAI_MODEL="gpt-4.1"

docker run -d  \
-e OPENAI_API_KEY=$OPENAI_API_KEY \
-e OPENAI_MODEL=$OPENAI_MODEL \
$full_image_name

# Pass all required env varialbes by .env file and flag
docker run -d \
--env-file=.env \
-e OPENAI_API_KEY=$OPENAI_API_KEY \
$full_image_name

```

## Basic Docker commands for operation
```bash

# pull alpine image
base_image_version="alpine:3.24.1"

docker pull "${base_image_version}"

# list all containers
docker ps -a

# list only the containers id
docker ps -aq

# Force to delete all containers (running or not)
docker rm -f $(docker ps -aq)

```


