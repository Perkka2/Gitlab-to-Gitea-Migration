#!/bin/bash
GITLAB_USERNAME=gitlabuser
GITLAB_PASSWORD=password
GITLAB_TOKEN=gitlab-token123
GITLAB_URL=https://gitlab.server
GITLAB_PROJECT=oldproject

GITEA_USERNAME=giteauser
GITEA_PASSWORD=password
GITEA_ADDRESS=http://gitea.server:3000
GITEA_REPO_OWNER=migration-org


page=1

while : ; do
   URL=$(curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" -s "$GITLAB_URL/api/v4/projects?per_page=1&page=$page" | jq -r '.[].web_url')
    page=$((page+1))
    if [ -z "$URL" ]; then
        break
    fi
    if [ -z $(echo $URL | grep $GITLAB_URL/$GITLAB_PROJECT) ];then
      echo "Found $URL, skipping"
      continue
    fi
    if [ ! -z $(echo $URL | grep deletion_scheduled) ];then
      echo "Found $URL, skipping"
      continue
    fi
    echo "Found $URL, getting name"

    REPO_NAME=$(echo $URL | sed "s|$GITLAB_URL/$GITLAB_PROJECT/||g")

    echo "Found $REPO_NAME, importing..."

    curl -X POST "$GITEA_ADDRESS/api/v1/repos/migrate" -u $GITEA_USERNAME:$GITEA_PASSWORD -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \
    \"auth_username\": \"$GITLAB_USERNAME\", \
    \"auth_password\": \"$GITLAB_PASSWORD\", \
    \"clone_addr\": \"$URL\", \
    \"mirror\": false, \
    \"private\": true, \
    \"pull_requests\": true, \
    \"issues\": true, \
    \"labels\": true, \
    \"releases\": true, \
    \"milestones\": true, \
    \"repo_name\": \"$REPO_NAME\", \
    \"repo_owner\": \"$GITEA_REPO_OWNER\", \
    \"service\": \"gitlab\", \
    \"uid\": 0, \
    \"wiki\": true}"

done