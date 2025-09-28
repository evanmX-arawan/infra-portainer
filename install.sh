#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "🚀 Starting Portainer installation on Amazon Linux 2023..."

# 1. Update the system
echo "🔄 Updating system packages..."
sudo dnf update -y

# 2. Install Docker if not already installed
if ! command -v docker &> /dev/null
then
    echo "🐳 Installing Docker..."
    sudo dnf install -y docker
    sudo systemctl enable --now docker
else
    echo "🐳 Docker is already installed."
fi

# 3. Add ec2-user to docker group (optional but recommended)
sudo usermod -aG docker ec2-user
echo "👤 Added ec2-user to the docker group. You may need to log out and back in."

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
echo "🌐 Access Portainer at: http://<your-ec2-public-ip>:9000"
echo "🛡️ Ensure port 9000 is open in your EC2 Security Group settings."


#ssh -i "D:\1CBKEY\infra-key.pem" ec2-user@10.15.44.82 !x1play!