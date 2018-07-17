FROM ubuntu:latest

# Install basics
RUN apt-get update && apt-get install -y \
    bzip2 \
    bash \
    curl \
    dumb-init \
    gnupg \
    locales \
    openssl \
    libssl-dev \
    perl \
    sudo &&\
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

# Create the user who can run nix
RUN useradd -ms /bin/bash nix_user && \
    usermod -aG sudo nix_user && \
    echo "nix_user      ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to the user for the rest of installation
USER nix_user
WORKDIR /home/nix_user
ENV USER nix_user

# Run the installer script
RUN curl https://nixos.org/nix/install > /tmp/nix_installer.sh && \
    chmod +x /tmp/nix_installer.sh && \
    /bin/bash /tmp/nix_installer.sh

ADD .bashrc /home/nix_user/.bashrc

# Run bash as pid 0
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]