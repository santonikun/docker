# Cheat Sheet - Kali Linux Docker Commands

## Startup & Shutdown

```bash
# Build dan run container
docker-compose up -d

# Atau gunakan helper script
./kali-docker.sh up

# Stop container
docker-compose stop
# atau
./kali-docker.sh stop

# Remove container
docker-compose down
# atau
./kali-docker.sh down

# Restart container
docker-compose restart
# atau
./kali-docker.sh restart
```

## Accessing Container

```bash
# Akses shell
docker-compose exec kali bash
# atau
./kali-docker.sh shell

# Execute command
docker-compose exec kali [command]
# atau
./kali-docker.sh exec [command]

# Example
./kali-docker.sh exec nmap -sV localhost
```

## File Transfer

```bash
# Copy file TO container
docker cp file.txt kali-linux:/root/

# Copy file FROM container
docker cp kali-linux:/root/file.txt ./

# Atau gunakan transfer script
./transfer.sh to ./file.txt /root/
./transfer.sh from /root/file.txt ./
```

## Monitoring

```bash
# View logs
docker-compose logs kali
# Follow logs
docker-compose logs -f kali

# Resource usage
docker stats kali-linux

# Container info
docker ps

# All Docker info
docker-compose ps
```

## Image Management

```bash
# List images
docker images

# Image size
docker images | grep kali

# Remove image
docker rmi kali-linux-complete:latest

# Build new image
docker-compose build

# Build without cache
docker-compose build --no-cache

# Image history
docker history kali-linux-complete:latest
```

## Volume Management

```bash
# List volumes
docker volume ls

# Volume info
docker volume inspect kali-home

# Backup volume
docker run --rm -v kali-home:/data -v $(pwd):/backup \
  alpine tar czf /backup/kali-home-backup.tar.gz -C / data

# Restore volume
docker run --rm -v kali-home:/data -v $(pwd):/backup \
  alpine tar xzf /backup/kali-home-backup.tar.gz -C /

# Remove unused volumes
docker volume prune
```

## Network

```bash
# List networks
docker network ls

# Network info
docker network inspect kali-network

# Connect container to network
docker network connect kali-network container-name

# Disconnect from network
docker network disconnect kali-network container-name
```

## Common Tools Commands

### Scanning
```bash
# Quick scan
nmap -sV target.com

# Full scan
nmap -sV -p- -A target.com

# Aggressive
nmap -T4 -A -v target.com

# Mass scan with masscan
masscan 0.0.0.0/0 -p 1-65535 --rate=100000
```

### Web Testing
```bash
# Nikto scan
nikto -h target.com

# SQLMap test
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Burp Suite
burpsuite
```

### Cracking
```bash
# John the Ripper
john --format=sha512crypt hashes.txt

# Hashcat
hashcat -m 1000 hashes.txt wordlist.txt

# Hydra brute force
hydra -l admin -P wordlist.txt target.com http-post-form
```

### Exploitation
```bash
# Metasploit
msfconsole

# Search exploit
search type:exploit platform:windows
```

### Network Analysis
```bash
# Capture packets
tcpdump -i eth0 -w capture.pcap

# Wireshark
wireshark

# Aircrack-ng
airmon-ng check
airmon-ng start wlan0
airodump-ng wlan0mon
```

## Useful One-Liners

```bash
# Access shell quickly
docker-compose exec kali bash -l

# Run command without entering shell
docker-compose exec kali nmap -sV localhost

# Check container status
docker-compose ps

# Rebuild and restart
docker-compose down && docker-compose build --no-cache && docker-compose up -d

# Full cleanup
docker-compose down && docker volume prune -f && docker image prune -f

# Interactive Python
docker-compose exec kali python3 -i -c "import scapy.all as scapy"

# View docker stats continuous
watch -n 1 'docker stats --no-stream kali-linux'

# Backup entire container filesystem
docker cp kali-linux:/ backup-kali/

# Check resource usage
docker exec kali free -h && docker exec kali df -h

# Update packages inside container
docker exec kali apt-get update && docker exec kali apt-get upgrade -y

# Install new tool
docker exec kali apt-get install -y tool-name

# View Kali Linux version
docker exec kali cat /etc/os-release
```

## Database Access

```bash
# PostgreSQL (from host)
psql -h localhost -U admin -d testdb

# MySQL (from host)
mysql -h localhost -u admin -p admin123

# Or from inside container
docker-compose exec postgres psql -U admin -d testdb
docker-compose exec mysql mysql -u admin -p admin123
```

## SSH Access (if configured)

```bash
# Generate key
ssh-keygen -t rsa -b 4096

# Copy key
docker cp ~/.ssh/id_rsa.pub kali-linux:/root/.ssh/authorized_keys

# SSH in
ssh -p 22 root@localhost

# With port forwarding
ssh -p 22 -L 8080:localhost:80 root@localhost
```

## Helper Script Usage

```bash
# Show help
./kali-docker.sh help

# Build image
./kali-docker.sh build

# Full setup and start
./kali-docker.sh up

# Open shell
./kali-docker.sh shell

# Execute command
./kali-docker.sh exec whoami

# Stop
./kali-docker.sh stop

# Show status
./kali-docker.sh status

# View logs
./kali-docker.sh logs

# Cleanup
./kali-docker.sh clean
```

## Environment Variables

```bash
# Set in docker-compose.yml
environment:
  - MY_VAR=value

# Or pass at runtime
docker run -e MY_VAR=value kali-linux-complete:latest
```

## Performance Tuning

```bash
# Check resource limits
docker inspect kali-linux | grep -A 10 '"Resources"'

# Update limits temporarily
docker update --memory=4G kali-linux

# Monitor in real-time
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## Troubleshooting

```bash
# Verbose build
docker-compose build --progress=plain

# Check build cache
docker system df

# Inspect container
docker inspect kali-linux

# Check logs for errors
docker-compose logs | grep -i "error\|warning"

# Verify network connectivity
docker exec kali ping 8.8.8.8

# Check DNS
docker exec kali cat /etc/resolv.conf

# Force rebuild
docker-compose build --force-rm --pull
```

---

**Pro Tips:**
- Use `./kali-docker.sh` for simplicity
- Regular backups of volumes: `docker-compose exec postgres pg_dump`
- Monitor disk space: `docker system df`
- Keep images updated: `docker pull kalilinux/kali-rolling`
- Document custom changes in comments
