#!/bin/bash

set -euo pipefail

echo "======================================="
echo "Configuring Bash GPT development environment"
echo "======================================="



# --------------------------------------------------------
# Development packages
# --------------------------------------------------------

sudo apt-get update

sudo apt-get install -y \
    --no-install-recommends \
    shellcheck \
    jq \
    curl \
    openssh-client \
    ca-certificates

sudo rm -rf /var/lib/apt/lists/*


# --------------------------------------------------------
# SSH
# --------------------------------------------------------

SSH_HOME="${HOME}/.ssh"

mkdir -p  "${SSH_HOME}"
chmod 700 "${SSH_HOME}"

SSH_CONFIG="${SSH_HOME}/config"

touch "${SSH_CONFIG}"
chmod 600 "${SSH_CONFIG}"

# github-sparta is an alias
# Authentication is still performed using the SSH agent
# forwarded fro the host
if ! grep -q "^Host github-sparta$" "${SSH_CONFIG}"; then
    cat >> "${SSH_CONFIG}" <<'EOF'

Host github-sparta
    Hostname github.com
    User git
EOF

fi


# --------------------------------------------------------
# Project directories
# --------------------------------------------------------

mkdir -p artifacts
mkdir -p responses
mkdir -p target

# --------------------------------------------------------
# Make project scripts executable
# --------------------------------------------------------

find commands scripts \
    -type f \
    -name "*.sh" \
    -exec chmod +x {} \;

# --------------------------------------------------------
# Environment validation
# --------------------------------------------------------

echo ""
echo "Development environment"
echo "-------------------------"

printf "Bash:         "
bash --version | head -1

printf "Git:          "
git --version

printf "Docker:          "
docker --version || true

printf "Compose:          "
docker compose version || true

printf "ShellCheck:          "
shellcheck --version | grep '^version:' || true

printf "jq:          "
jq --version

printf "curl:          "
curl --version | head -1

printf "SHH agent:          "
if ssh-dd -1 >/dev/null 2>&1; then
    echo "available"
else
    echo "not available or no keys loaded"
fi

printf "OpenAI key:          "
if [[ -n "${OPENAI_API_KEY:-}" ]]; then
    echo "defined"
else
    echo "NOT defined"
fi

echo ""
echo "Dev container configuration completed"

