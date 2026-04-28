#!/bin/bash
set -euo pipefail   # strict mode

echo
echo -e "\e[36mChecking npm...\e[0m"
npm install

echo
echo -e "\e[36mOutdated:\e[0m"
npm outdated --depth=0 || true

echo
echo -e "\e[36mSecurity audit (high level):\e[0m"
npm audit --audit-level=high

echo
echo -e "\e[36mSecurity audit (normal level):\e[0m"
npm audit
