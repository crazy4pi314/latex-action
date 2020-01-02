# Container image that runs your code
FROM mcr.microsoft.com/powershell:7.0.0-rc.1-ubuntu-xenial

RUN apt-get update && \
    apt-get -y install \
        texlive texlive-extra-fonts texlive-xetex && \
    # We clean the apt cache at the end of each apt command so that the caches
    # don't get stored in each layer.
    apt-get clean && rm -rf /var/lib/apt/lists/

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.ps1 /entrypoint.ps1
RUN chmod +x /entrypoint.ps1

# Code file to execute when the docker container starts up (`entrypoint.ps1`)
ENTRYPOINT ["/entrypoint.ps1"]
