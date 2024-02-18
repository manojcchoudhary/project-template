#!/bin/bash

# Prompt for user input
read -p "Enter your actual project name: " ACTUAL_PROJECT_NAME
read -p "Enter your database user: " PG_DATABASE_USER
read -p "Enter your database name: " PG_DATABASE_NAME
read -p "Enter your database password: " PG_DATABASE_PASSWORD
read -p "Enter your database table prefix: " PG_DATABASE_TABLE_PREFIX
read -p "Enter your NextAuth secret: " NEXT_AUTH_SECRET
read -p "Enter your Google client ID: " GOOGLE_CLIENT_ID
read -p "Enter your Google client secret: " GOOGLE_CLIENT_SECRET
read -p "Enter your new GitHub URL for remote origin: " GITHUB_URL

# Copy .env.example to .env if it exists
if [[ -f ".env.example" ]]; then
    cp .env.example .env
    echo ".env file created from .env.example."
fi

# Determine OS and adjust sed command accordingly
SED_CMD="sed -i"
BACKUP_EXT=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires an empty string argument for in-place editing with sed
    SED_CMD="sed -i ''"
fi

# Keywords to search for in files before updating
KEYWORDS="project_name|PG_DATABASE_USER|PG_DATABASE_NAME|PG_DATABASE_PASSWORD|PG_DATABASE_TABLE_PREFIX|NEXT_AUTH_SECRET_PLACEHOLDER|GOOGLE_CLIENT_ID_PLACEHOLDER|GOOGLE_CLIENT_SECRET_PLACEHOLDER"

# Find and update files, excluding specific directories and the script file
find . \( -path ./node_modules -o -path ./.git -o -path ./.next -o -name update-project-template.sh -o -name .env.example \) -prune -o -type f -exec grep -Elq "$KEYWORDS" {} \; -exec bash -c "$SED_CMD $BACKUP_EXT 's/project_name/$ACTUAL_PROJECT_NAME/g; s/PG_DATABASE_USER/$PG_DATABASE_USER/g; s/PG_DATABASE_NAME/$PG_DATABASE_NAME/g; s/PG_DATABASE_PASSWORD/$PG_DATABASE_PASSWORD/g; s/PG_DATABASE_TABLE_PREFIX/$PG_DATABASE_TABLE_PREFIX/g; s/NEXT_AUTH_SECRET_PLACEHOLDER/$NEXT_AUTH_SECRET/g; s/GOOGLE_CLIENT_ID_PLACEHOLDER/$GOOGLE_CLIENT_ID/g; s/GOOGLE_CLIENT_SECRET_PLACEHOLDER/$GOOGLE_CLIENT_SECRET/g' {}" \; -exec echo "Updated {}" \;

# Update Git remote origin URL if .git/config exists
if [[ -f ".git/config" ]] && [[ -n "$GITHUB_URL" ]]; then
    git remote set-url origin "$GITHUB_URL"
    echo "Git remote origin URL has been updated."
fi

echo "Project settings have been updated in all applicable files."
