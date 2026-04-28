#!/bin/bash
set -euo pipefail   # strict mode

echo
echo -e "\e[36mChecking composer...\e[0m"
composer install --prefer-dist
composer validate --strict

echo
echo -e "\e[36mOutdated:\e[0m"
composer outdated --direct

echo
echo -e "\e[36mSecurity audit:\e[0m"
echo "Security audit:"
composer audit
