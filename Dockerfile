# Container image that runs your code
FROM mcr.microsoft.com/powershell:7.0.0-rc.1-ubuntu-xenial

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.ps1 /entrypoint.ps1

# Code file to execute when the docker container starts up (`entrypoint.ps1`)
ENTRYPOINT ["/entrypoint.ps1"]
