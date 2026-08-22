#!/bin/bash

set -euo pipefail

echo "======================================="
echo "Configuring Bash GPT development environment"
echo "Alpine Linux"
echo "======================================="


# --------------------------------------------------------
# SSH configuration
# --------------------------------------------------------

SSH_HOME="${HOME}/.ssh"
SSH_CONFIG="${SSH_HOME}/config"

mkdir -p "${SSH_HOME}"
chmod 700 "${SSH_HOME}"

touch "${SSH_CONFIG}"
chmod 600 "${SSH_CONFIG}"

# github-sparta is only an alias.
# The private key is NEVER copied into the container.
# Authentication uses the SSH agent forwarded from the host.

if ! grep -q "^Host github-spart$" "${SSH_CONFIG}"; then
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

for directory in commands scripts; do
    if [[ -d "${directory}" ]]; then
        find "${directory}" \
            -type f \
            -name "*.sh" \
            -exec chmod +x {} +
    fi
done

# --------------------------------------------------------
# Environment information
# --------------------------------------------------------

echo ""
echo "Development environment"
echo "-------------------------"

printf "Alpine: "
cat /etc/alpine-release

printf "Bash: "
bash --version | head -1


printf "Git: "
git --version

printf "GitHub CLI: "
gh --version | head -1

printf "Docker CLI: "
docker --versioin || true

printf "Compose: "
docker compose version || true

printf "ShellCheck: "
shellcheck --version | grep '^version:' || true

printf "jq: "
jq --version

printf "curl: "
curl --version | head -1


# --------------------------------------------------------
# SSH agent
# --------------------------------------------------------

if ssh-add -l >/dev/null 2>&1; then
    echo "available - key(s) loaded"
else
    echo "not available or no keys loaded"
fi


# --------------------------------------------------------
# Git Identity
# --------------------------------------------------------

echo ""
echo "Git identity"
echo "------------"


GIT_NAME="$(git config --get user.name || true)"
GIT_EMAIL="$(git config --get user.email || true)"

if [[ -n "${GIT_NAME}" ]]; then
    echo "Name: ${GIT_NAME}"
else
    echo "Name: NOT configured"
fi


if [[ -n "${GIT_EMAIL}" ]]; then
    echo "Email: ${GIT_EMAIL}"
else
    echo "Email: NOT configured"
fi

if [[ -z "${GIT_NAME}" || -z "${GIT_EMAIL}" ]]; then
    echo ""
    echo "Git Identity is not fully configured"
    echo "Configure it for this repository with:"
    echo ""
    echo 'git config --local user.name "Your Name"'
    echo 'git config --local user.email "your@email.com"'
fi


# --------------------------------------------------------
# OPENAI_API_KEY
# --------------------------------------------------------

echo ""
printf "OpenAI key: "

if [[ -n "${OPENAI_API_KEY:-}" ]]; then
    echo "defined"
else
    echo "NOT defined"
fi

echo ""
echo "Dev container configuration completed"
