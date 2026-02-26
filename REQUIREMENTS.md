# Kali Linux Docker - Requirements & Compatibility

## 📋 System Requirements

### Minimum Requirements
- **OS**: Linux, macOS, or Windows (with WSL2)
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 1.29.0 or higher
- **Disk Space**: 6-8GB (for base image + tools)
- **RAM**: 4GB minimum (2GB for container, 2GB for host)
- **CPU**: 2 cores minimum

### Recommended Requirements
- **Disk Space**: 15-20GB (for comfortable operation with tools)
- **RAM**: 8GB or more
- **CPU**: 4 cores or more
- **Network**: Stable internet connection (for building)

## 🔧 Software Dependencies

### Required
```
- Docker >= 20.10
- Docker Compose >= 1.29.0
```

### Optional (for advanced usage)
```
- Git (for cloning this repo)
- SSH client (for SSH access to container)
- curl/wget (for downloading tools)
- bash >= 4.0 (for helper scripts)
```

## 💻 Operating System Compatibility

| OS | Status | Notes |
|---|---|---|
| Linux (Ubuntu 20.04+) | ✅ Full Support | Recommended for best performance |
| Linux (Debian 11+) | ✅ Full Support | Good alternative |
| Linux (CentOS 8+) | ✅ Full Support | May need yum instead of apt |
| macOS (Intel) | ✅ Full Support | Requires Docker Desktop |
| macOS (Apple Silicon/M1/M2) | ⚠️ Partial | May have performance issues |
| Windows 10/11 (WSL2) | ✅ Full Support | Requires Windows 10 Build 2004+ |
| Windows 10/11 (Hyper-V) | ✅ Full Support | Alternative to WSL2 |

## 🐳 Docker Version Compatibility

| Docker Version | Compose Version | Status |
|---|---|---|
| 20.10.x | 1.29.x | ✅ Supported |
| 20.10.x | 2.0.x+ | ✅ Supported |
| 20.10.x+ | 2.1.x+ | ✅ Supported (Recommended) |
| 19.03.x | 1.25.x+ | ⚠️ May work but not tested |
| < 19.03 | Any | ❌ Not supported |

## 📦 Container Base Image

```
kalilinux/kali-rolling:latest
```

- **Size**: ~750MB (base image)
- **Size with tools**: ~3-4GB (full image with all tools)
- **Update frequency**: Continuously updated
- **Registry**: Docker Hub

## 🔌 Ports Required

Make sure these ports are available on your host:

```
22   - SSH
80   - HTTP
443  - HTTPS
8080 - HTTP Alternative
8443 - HTTPS Alternative
3306 - MySQL
5432 - PostgreSQL
5900 - VNC
9200 - Elasticsearch
```

If ports are already in use, you can modify them in `docker-compose.yml`:

```yaml
ports:
  - "2222:22"  # Instead of 22:22
```

## 🌐 Network Requirements

### For Building Image:
- **Download**: ~2-3GB
- **Internet**: Stable connection recommended
- **Time**: 30-60 minutes depending on connection and machine

### For Running:
- Container has network access to communicate with:
  - Host machine
  - Internet (for downloading tools/exploits)
  - Other containers (PostgreSQL, MySQL)

## 💾 Storage Requirements

### Disk Space Breakdown

| Component | Size |
|-----------|------|
| Base Image | ~800MB |
| Metasploit | ~500MB |
| Web Testing Tools | ~300MB |
| Wordlists | ~500MB |
| Additional Tools | ~1GB+ |
| Volumes (persistent) | ~500MB-2GB |
| **Total** | **~4-5GB minimum** |

### Clean Up Unused Space

```bash
# Remove dangling images and containers
docker system prune -a

# Remove unused volumes
docker volume prune

# Check disk usage
docker system df
```

## 🔐 Security Considerations

1. **Network Isolation**: Container runs in isolated network by default
2. **Privilege Level**: Runs with `NET_ADMIN` capability (not full privileged)
3. **User**: Runs as root (normal for Kali Linux)
4. **File Permissions**: Be careful with volumes containing sensitive data

## ⚠️ Known Issues & Limitations

### Platform-Specific

**macOS (Apple Silicon)**:
- May require additional configuration
- Some tools might not be fully optimized
- Performance may be impacted

**Windows (WSL2)**:
- Path handling may differ
- Docker volume mounts might be slower
- File permissions issues possible

**Windows (Hyper-V)**:
- Resource overhead from Hyper-V
- Network configuration needs adjustment

### General

- Large builds may take time (network dependent)
- Some tools require X11 display (for GUI)
- Network scanning tools may have limitations in container
- Wireless tools (aircrack-ng) need special host configuration

## 🚀 Installation Steps

### 1. Install Docker
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# macOS (with Homebrew)
brew install docker docker-compose

# Windows
# Download Docker Desktop from https://www.docker.com/products/docker-desktop
```

### 2. Verify Installation
```bash
docker --version
docker-compose --version
docker run hello-world
```

### 3. Clone or Download This Repository
```bash
git clone https://github.com/santonikun/docker.git
cd docker
```

### 4. Run Verification
```bash
bash verify.sh
```

### 5. Build and Run
```bash
./kali-docker.sh up
```

## 📦 Python Version

- **Python Version in Container**: Python 3.11+
- **PIP Version**: Latest
- **Virtual Environment**: Not used (runs directly in container)

## 🎯 Tested Environments

- ✅ Ubuntu 20.04 LTS + Docker 20.10
- ✅ Ubuntu 22.04 LTS + Docker 20.10+
- ✅ Debian 11 + Docker 20.10+
- ✅ Docker Desktop for Mac + M1 Pro
- ✅ Windows 11 + WSL2 + Docker Desktop
- ⚠️ CentOS 8 (requires additional setup)

## 📚 Useful Resources

- [Docker Installation Guide](https://docs.docker.com/engine/install/)
- [Docker Compose Installation](https://docs.docker.com/compose/install/)
- [Kali Linux Official Repo](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Enable WSL2 on Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install)

## 🆘 Troubleshooting Install

### Docker Not Found
```bash
# Reinstall Docker
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker $USER
```

### Permission Denied
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Logout and login again, or
newgrp docker
```

### Docker Daemon Not Running
```bash
# Start Docker daemon
sudo systemctl start docker

# Or on macOS
open /Applications/Docker.app
```

### Out of Memory During Build
```bash
# Increase Docker memory allocation
# Edit ~/.docker/config.json or Docker Desktop Settings
# Set memory to 4GB or more
```

---

**Last Updated**: February 2024
**Compatible With**: Kali Linux Rolling Release
