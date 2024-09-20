#!/data/data/com.termux/files/usr/bin/bash

# Update and install necessary packages
pkg update -y
pkg install -y nginx nodejs

# Install code-server
npm install -g code-server

# Create Nginx configuration directory
mkdir -p ~/.config/nginx

# Create Nginx configuration file
cat > ~/.config/nginx/nginx.conf << EOL
events {
    worker_connections 1024;
}

http {
    server {
        listen 8080;
        server_name localhost;

        location / {
            proxy_pass http://localhost:8081;
            proxy_set_header Host \$host;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection upgrade;
            proxy_set_header Accept-Encoding gzip;
        }
    }
}
EOL

# Create code-server configuration file
mkdir -p ~/.config/code-server
cat > ~/.config/code-server/config.yaml << EOL
bind-addr: 127.0.0.1:8081
auth: password
password: $(openssl rand -base64 12)
cert: false
EOL

# Start code-server in the background
code-server --config ~/.config/code-server/config.yaml &

# Start Nginx
nginx -c ~/.config/nginx/nginx.conf

# Display information
echo "Setup complete!"
echo "code-server is running on http://localhost:8080"
echo "Password is stored in ~/.config/code-server/config.yaml"
echo "Remember to set up port forwarding on your router for port 8080"
echo "To access from outside, use your public IP address or set up a dynamic DNS"
