

```bash

echo "List Models"
curl --silent --show-error \
  "https://api.openai.com/v1/models" \
  --header "Authorization: Bearer ${OPENAI_API_KEY}" \
  | jq


curl --silent --show-error \
    --write-out "%{http_code}" "https://api.openai.com/v1/models/${OPENAI_MODEL}" \
    --header "Authorization: Bearer ${OPENAI_API_KEY}" 

  | jq


curl --silent --show-error \
    --write-out "%{http_code}" "https://api.openai.com/v1/models/chanchito_model" \
    --header "Authorization: Bearer ${OPENAI_API_KEY}" 
  | jq


```