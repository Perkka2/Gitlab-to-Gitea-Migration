## This script will copy repositorys from a GitLab server to Gitea using their API's for readout existing repos and initiating migrations using the built in migration tool.

It will copy issues, pull-requests, milestones, wiki, labels and releases.

## Edit the script and add the needed info

GITLAB_USERNAME=gitlabuser
GITLAB_PASSWORD=password
GITLAB_TOKEN=gitlab-token123
GITLAB_URL=https://gitlab.server
GITLAB_PROJECT=oldproject

GITEA_USERNAME=giteauser
GITEA_PASSWORD=password
GITEA_ADDRESS=http://gitea.server:3000
GITEA_REPO_OWNER=migration-org
