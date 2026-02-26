FROM kalilinux/kali-rolling:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    PATH="/root/.local/bin:${PATH}"

# Update and install base packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    ca-certificates \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    net-tools \
    iputils-ping \
    dnsutils \
    telnet \
    openssh-client \
    openssh-server \
    sudo \
    apt-utils \
    dialog \
    && locale-gen en_US.UTF-8

# Install Kali Linux tools - Common metapackages
RUN apt-get install -y --no-install-recommends \
    kali-tools-web \
    kali-tools-information-gathering \
    kali-tools-vulnerability-assessment \
    kali-tools-exploitation

# Install additional security tools
RUN apt-get install -y --no-install-recommends \
    nmap \
    metasploit-framework \
    burpsuite \
    sqlmap \
    nikto \
    hydra \
    hashcat \
    john \
    aircrack-ng \
    wireshark \
    tcpdump \
    masscan \
    gobuster \
    wordlists \
    tor \
    torsocks \
    python3 \
    python3-pip \
    python3-dev \
    ruby \
    openjdk-11-jdk \
    go-lang \
    gcc \
    make \
    binutils \
    gdb \
    strace \
    ltrace

# Install Python security libraries
RUN python3 -m pip install --no-cache-dir \
    requests \
    paramiko \
    beautifulsoup4 \
    scapy \
    pycryptodome \
    selenium \
    pwntools \
    flask \
    django \
    twisted

# Create a non-root user (optional but recommended)
RUN useradd -m -s /bin/bash -u 1000 hacker && \
    usermod -aG sudo hacker && \
    echo "hacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure SSH
RUN mkdir -p /run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create SSH keys for root
RUN mkdir -p /root/.ssh && \
    ssh-keygen -A

# Clean up
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /root

# Expose common ports
EXPOSE 22 80 443 8080 8443 3306 5432 5900 9200

# Start bash by default
CMD ["/bin/bash"]
