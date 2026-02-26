# Kali Linux Docker Container

Ini adalah setup Docker lengkap untuk menjalankan **Kali Linux** dengan semua tools penetration testing yang diperlukan.

## 📋 Isi Container

### Tools Utama yang Diinstal:
- **Web Penetration Testing**: Burp Suite, nikto, sqlmap
- **Network Scanning & Enumeration**: Nmap, Masscan, Gobuster
- **Exploitation**: Metasploit Framework
- **Wireless Testing**: Aircrack-ng
- **Password Cracking**: Hashcat, John the Ripper, Hydra
- **Network Analysis**: Wireshark, TCPdump
- **Proxy & Anonymity**: Tor, Torsocks
- **Development Tools**: Python 3, Ruby, Go, Java, GCC

### Database (Optional):
- PostgreSQL 15
- MySQL 8.0

## 🚀 Quick Start

### 1. Build dan Jalankan dengan Docker Compose

```bash
# Clone/navigate ke directory ini
cd /workspaces/docker

# Build image Kali Linux
docker-compose build

# Jalankan container
docker-compose up -d

# Akses container
docker-compose exec kali bash
```

### 2. Atau Build Manual dengan Docker

```bash
# Build image
docker build -t kali-linux-complete:latest .

# Jalankan interactive
docker run -it --rm kali-linux-complete:latest bash

# Jalankan dengan volume dan ports
docker run -it --rm \
  -v $(pwd)/workspace:/root/workspace \
  -p 22:22 -p 80:80 -p 443:443 -p 8080:8080 \
  --cap-add=NET_ADMIN \
  kali-linux-complete:latest bash
```

## 📁 Struktur Directory

```
.
├── Dockerfile                 # Docker image Kali Linux
├── docker-compose.yml         # Docker compose configuration
├── workspace/                 # Directory untuk projects (untuk host)
└── shared/                    # Shared directory antara host dan container
```

## 🔧 Penggunaan

### Akses Container

```bash
# Menggunakan docker-compose
docker-compose exec kali bash

# Atau jika run manual
docker exec -it kali-linux bash

# SSH ke container (jika dijalankan dengan port forwarding)
ssh -p 22 root@localhost
```

### Mount Files dari Host

```bash
# File sudah otomatis di-mount:
# - ./workspace → /root/workspace di container
# - ./shared → /shared di container

# Copy file ke container
docker cp local_file.txt container_name:/root/
```

## 🛠️ Tools yang Sering Digunakan

```bash
# Scanning
nmap -sV -p- target.com
masscan 0.0.0.0/0 -p1-65535

# Web Testing
burpsuite
nikto -h target.com
sqlmap -u "http://target.com" -p id

# Password Cracking
hashcat -m 1000 hashes.txt wordlist.txt
john hashes.txt

# Metasploit
msfconsole

# Enumeration
gobuster dir -u http://target.com -w wordlist.txt

# Network Analysis
wireshark
tcpdump -i eth0 -w capture.pcap

# Python Scripts
python3 script.py
```

## 🔐 Keamanan & Konfigurasi

### Credentials Default
- **User**: root (atau hacker untuk non-root)
- **Password**: (setup sesuai kebutuhan)

### SSH Akses
SSH sudah dikonfigurasi, untuk menggunakan:

```bash
# Generate SSH key jika belum ada
ssh-keygen -t rsa -b 4096

# Copy key ke container
docker cp ~/.ssh/id_rsa.pub container_name:/root/.ssh/authorized_keys

# SSH ke container
ssh -p 22 root@localhost
```

### Network Capabilities
Container di-configure dengan NET_ADMIN capability untuk tools seperti aircrack-ng. Jika butuh akses penuh, uncomment `privileged: true` di docker-compose.yml (dengan hati-hati!).

## 📊 Resources

Konfigurasi default resources:
- **CPU**: 1-2 cores
- **Memory**: 2-4 GB

Sesuaikan di docker-compose.yml pada section `deploy.resources`.

## 🧹 Housekeeping

```bash
# Lihat container running
docker ps

# Lihat semua images
docker images

# Stop container
docker-compose stop

# Remove container
docker-compose down

# Remove image
docker rmi kali-linux-complete:latest

# Cleanup volume (WARNING: data akan hilang)
docker volume prune
```

## 🐛 Troubleshooting

### "Error response from daemon"
```bash
# Restart Docker daemon
sudo systemctl restart docker
```

### Build gagal di network
```bash
# Build dengan network host
docker build --network host -t kali-linux-complete:latest .
```

### Permission denied di SSH
```bash
# Fix SSH key permissions
docker exec kali chmod 700 /root/.ssh
docker exec kali chmod 600 /root/.ssh/authorized_keys
```

## 📝 Customization

### Tambah Tools Baru

Edit `Dockerfile` dan tambahkan:

```dockerfile
RUN apt-get install -y --no-install-recommends \
    tool-name-1 \
    tool-name-2
```

Kemudian rebuild:
```bash
docker-compose build --no-cache
```

### Custom Python Dependencies

Edit `Dockerfile` di section `python3 -m pip install` atau:

```bash
docker exec kali pip install package-name
```

## 🌐 Port Mappings

| Service | Port | Container Port |
|---------|------|-----------------|
| SSH | 22 | 22 |
| HTTP | 80 | 80 |
| HTTPS | 443 | 443 |
| Alt HTTP | 8080 | 8080 |
| Alt HTTPS | 8443 | 8443 |
| MySQL | 3306 | 3306 |
| PostgreSQL | 5432 | 5432 |
| VNC | 5900 | 5900 |
| Elasticsearch | 9200 | 9200 |

## 📚 Referensi

- [Kali Linux Official Docker Image](https://hub.docker.com/r/kalilinux/kali-rolling)
- [Kali Linux Tools Documentation](https://tools.kali.org/)
- [Metasploit Framework](https://www.metasploit.com/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

## ⚖️ Disclaimer

Container ini dirancang untuk **educational dan authorized security testing purposes only**. Pastikan Anda memiliki izin sebelum melakukan penetration testing pada target manapun.

---

**Created for security professionals and ethical hackers** 🔐