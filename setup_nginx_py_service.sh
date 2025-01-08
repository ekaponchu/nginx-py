#!/bin/bash

# Update package list and install necessary packages
sudo apt-get update
sudo apt-get install -y nginx python3 python3-pip

# Ensure Nginx is installed and running
sudo systemctl enable nginx
sudo systemctl start nginx

# Create the directory for the Python script
sudo mkdir -p /etc/nginx-py

# Check if a valid port number is provided as an argument
if [ -n "$1" ] && [ "$1" -ge 3000 ] && [ "$1" -le 8000 ]; then
    PORT=$1
else
    PORT=8088
fi

# Create the Python script
sudo tee /etc/nginx-py/nginx.py > /dev/null << EOF
import subprocess
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/reload-nginx':
            self.reload_nginx()
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'Not Found')

    def reload_nginx(self):
        try:
            # Test the Nginx configuration
            subprocess.run(['nginx', '-t'], check=True)
            # Reload Nginx if the configuration test is successful
            subprocess.run(['nginx', '-s', 'reload'], check=True)
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Nginx configuration is valid and reloaded successfully')
        except subprocess.CalledProcessError:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b'Failed to reload Nginx due to invalid configuration')

def run(server_class=HTTPServer, handler_class=RequestHandler, port=int(os.getenv('PORT', 8088))):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()
EOF

# Create the systemd service file
sudo tee /etc/systemd/system/nginx-py-reload.service > /dev/null << EOF
[Unit]
Description=Python script to reload Nginx
After=network.target

[Service]
Environment="PORT=$PORT"
ExecStart=/usr/bin/python3 /etc/nginx-py/nginx.py
WorkingDirectory=/etc/nginx-py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable nginx-py-reload.service
sudo systemctl start nginx-py-reload.service

# Verify the service status
sudo systemctl status nginx-py-reload.service
