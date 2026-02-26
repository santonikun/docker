# Advanced Setup Guide - Kali Linux Docker

## 🔧 Konfigurasi Lanjutan

### 1. Customization Dockerfile

#### Menambah Tools Baru

Edit `Dockerfile` dan tambahkan di section yang sesuai:

```dockerfile
# Untuk tools dari repositori Kali
RUN apt-get install -y --no-install-recommends \
    tool-name-1 \
    tool-name-2 \
    tool-name-3

# Kemudian rebuild
docker-compose build --no-cache
```

#### Menginstal Python Packages

```dockerfile
RUN python3 -m pip install --no-cache-dir package-name
```

#### Menginstal dari Source

```dockerfile
RUN git clone https://github.com/repo/project.git /opt/project && \
    cd /opt/project && \
    ./setup.sh
```

### 2. Persistent Storage

Container sudah dikonfigurasi dengan volumes untuk:
- `/root` - Home directory (settings, tools, history)
- `/root/workspace` - Project workspace
- `/shared` - Shared files antara host dan container

**Untuk menambah volume baru di docker-compose.yml:**

```yaml
volumes:
  - ./my-data:/root/my-data
```

### 3. Environment Variables

Lihat `Dockerfile` untuk ENV variables yang tersedia. Untuk menambah:

```dockerfile
ENV MY_VAR="value"
```

### 4. Networking

Container tersambung ke custom bridge network `kali-network` yang memungkinkan komunikasi dengan services lain (PostgreSQL, MySQL, dll).

**Mengakses service dari container:**
```bash
# Di dalam container
psql -h postgres -U admin -d testdb
mysql -h mysql -u admin -p admin123
```

### 5. Privileged Access

Default: Container berjalan dengan capabilities terbatas (`--cap-add=NET_ADMIN`)

**Untuk full privileged access (tidak disarankan):**

Edit `docker-compose.yml`:
```yaml
services:
  kali:
    privileged: true
```

Rebuild dan restart:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 🌐 Port Forwarding

### Port yang Tersedia dari Host

| Purpose | Port |
|---------|------|
| SSH | 22 |
| HTTP | 80 |
| HTTPS | 443 |
| HTTP Alt | 8080 |
| HTTPS Alt | 8443 |
| MySQL | 3306 |
| PostgreSQL | 5432 |
| VNC | 5900 |
| Elasticsearch | 9200 |

### Menambah Port Baru

Edit `docker-compose.yml`:
```yaml
ports:
  - "9000:9000"  # Service kustom
```

## 🔐 Security Hardening

### SSH Access dengan Key

```bash
# 1. Generate SSH key (jika belum ada)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/kali_key

# 2. Copy public key ke container
docker cp ~/.ssh/kali_key.pub kali-linux:/root/.ssh/authorized_keys

# 3. Set permissions
docker exec kali chmod 700 /root/.ssh
docker exec kali chmod 600 /root/.ssh/authorized_keys

# 4. SSH ke container
ssh -i ~/.ssh/kali_key -p 22 root@localhost
```

### Disable Root SSH Login

Edit `Dockerfile`:
```dockerfile
RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
```

### Firewall Rules (di container)

```bash
docker exec kali apt-get install -y ufw
docker exec kali ufw default deny incoming
docker exec kali ufw allow 22/tcp
docker exec kali ufw enable
```

## 📊 Monitoring & Logging

### View Container Logs

```bash
# Real-time logs
docker-compose logs -f kali

# Last 100 lines
docker-compose logs --tail=100 kali

# Logs dengan timestamp
docker-compose logs --timestamps kali
```

### Resource Usage

```bash
# Docker stats
docker stats kali-linux

# Inside container
docker exec kali top
docker exec kali free -h
docker exec kali df -h
```

### Container Inspection

```bash
# Detailed container info
docker inspect kali-linux

# Network settings
docker inspect kali-linux | grep -A 10 '"Networks"'

# Mounted volumes
docker inspect kali-linux | grep -A 10 '"Mounts"'
```

## 🚀 Performance Optimization

### Memory Usage

Jika container terlalu berat, kurangi resource:

```yaml
deploy:
  resources:
    limits:
      memory: 2G
```

### Disk Usage

```bash
# Check volume sizes
docker volume inspect kali-home

# Cleanup unused volumes
docker volume prune

# Check image size
docker images | grep kali

# Layer information
docker history kali-linux-complete:latest
```

### Build Cache

```bash
# Build tanpa cache for fresh install
docker-compose build --no-cache

# Dengan cache (lebih cepat)
docker-compose build
```

## 🔄 CI/CD Integration

### GitHub Actions Example

`.github/workflows/docker-build.yml`:

```yaml
name: Build Kali Docker

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build Docker image
        run: docker build -t kali-linux-complete:latest .
      - name: Test container
        run: docker run --rm kali-linux-complete:latest nmap --version
```

## 📚 Tool-Specific Setup

### Metasploit

```bash
docker exec -it kali msfconsole

# Atau dengan database
docker exec -it kali msfdb init
docker exec -it kali msfconsole
```

### Burp Suite

```bash
# Run Burp headless
docker exec kali burpsuite &

# Atau dengan Docker GUI (memerlukan X11 forwarding)
```

### Python Tools

```bash
# Install custom script pip dependencies
docker exec kali pip install -r requirements.txt

# Atau langsung
docker exec kali pip install package-name
```

## 🐛 Common Issues & Solutions

### Host Tidak Bisa Ping Container

```bash
# Check network
docker network ls
docker network inspect kali-network

# Restart network
docker network disconnect kali-network kali-linux
docker network connect kali-network kali-linux
```

### Out of Disk Space

```bash
# Find dan clear old images
docker image prune -a

# Clear dangling volumes
docker volume prune

# Check disk usage
docker system df
```

### Cannot Connect to SSH

```bash
# Check SSH is running
docker exec kali service ssh status

# Restart SSH
docker exec kali service ssh restart

# Check SSH config
docker exec kali cat /etc/ssh/sshd_config | grep PermitRootLogin
```

### Slow Build Time

```bash
# Build with progress
docker-compose build --progress=plain

# Use BuildKit for faster builds
DOCKER_BUILDKIT=1 docker-compose build
```

## 📖 Dokumentasi Berguna

- [Docker Documentation](https://docs.docker.com/)
- [Kali Linux Tools](https://tools.kali.org/)
- [Metasploit Framework](https://docs.rapid7.com/metasploit/)
- [OWASP](https://owasp.org/)

---

**Last Updated**: 2024
**Kali Linux Version**: Rolling Release
