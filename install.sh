#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "🚀 Starting Portainer installation on Ubuntu/Debian..."

# 1. Update the system
echo "🔄 Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# 2. Install Docker if not already installed
if ! command -v docker &> /dev/null
then
    echo "🐳 Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
else
    echo "🐳 Docker is already installed."
fi

# 3. Add current user to docker group (optional but recommended)
sudo usermod -aG docker $USER
echo "👤 Added $USER to the docker group. You may need to log out and back in."

# 4. Create Portainer Docker volume
echo "💾 Creating Docker volume for Portainer..."
sudo docker volume create portainer_data

# 5. Run Portainer container
echo "🚀 Deploying Portainer container..."
sudo docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

echo "✅ Portainer installation complete!"
echo "🌐 Access Portainer at: http://<your-server-ip>:9000"
echo "🛡️ Ensure port 9000 is open in your firewall/security group settings."
