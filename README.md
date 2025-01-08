
![Logo](https://github.com/ekaponchu/nginx-py/blob/main/assets/Screenshot%202568-01-08%20at%2007.33.29.png?raw=true) 

# Nginx PY

The app server should reload the Nginx configuration using systemctl reload nginx whenever the Nginx configuration changes.


## Deployment

To deploy this project run

### **Run the Script**

Run the script to set up the service, optionally providing a port number:

```bash
  curl -fsSL https://raw.githubusercontent.com/ekaponchu/nginx-py/refs/heads/main/setup_nginx_py_service.sh -o setup_nginx_py_service.sh
  sudo sh setup_nginx_py_service.sh 8088
```

---

#### **To Stop the Python HTTP server**
the Python HTTP server running as a daemon, you can use the `systemctl` command to stop the systemd service that manages it. Here are the steps:

#### Step 1: Stop the Service

Use the following command to stop the service:

```
sudo systemctl stop nginx-py-reload.service

```

#### Step 2: Disable the Service (Optional)

If you want to prevent the service from starting automatically on boot, you can disable it:

```
sudo systemctl disable nginx-py-reload.service

```

#### Step 3: Verify the Service Status

You can verify that the service has stopped by checking its status:

```
sudo systemctl status nginx-py-reload.service

```

The output should indicate that the service is inactive (dead).

#### Summary

To stop the Python HTTP server running as a daemon, use the `systemctl stop` command followed by the service name. If you want to prevent it from starting on boot, use the `systemctl disable` command. Verify the status using `systemctl status`.

### **How to remove**

To remove the Python HTTP server and its associated systemd service, you need to stop and disable the service, then delete the service file and the Python script. Here are the steps:

#### Step 1: Stop and Disable the Service

Use the following commands to stop and disable the service:

```
sudo systemctl stop nginx-py-reload.service
sudo systemctl disable nginx-py-reload.service

```

#### Step 2: Remove the Systemd Service File

Delete the systemd service file:

```
sudo rm /etc/systemd/system/nginx-py-reload.service

```

#### Step 3: Reload Systemd Manager Configuration

Reload the systemd manager configuration to apply the changes:

```
sudo systemctl daemon-reload

```

#### Step 4: Remove the Python Script

Delete the Python script and its directory:

```
sudo rm -rf /etc/nginx-py

```

#### Summary

Here are all the commands combined:

```
sudo systemctl stop nginx-py-reload.service
sudo systemctl disable nginx-py-reload.service
sudo rm /etc/systemd/system/nginx-py-reload.service
sudo systemctl daemon-reload
sudo rm -rf /etc/nginx-py

```

This will completely remove the Python HTTP server and its associated systemd service from your system.


## API Reference

#### Reload Nginx

```http
  curl localhost:8088/reload-nginx
```

| Response | Type     | Message                |
| :-------- | :------- | :------------------------- |
| `200` | `Suceess` | Nginx configuration is valid and reloaded successfully |





## Related

Here are some related projects

[schenkd nginx-ui](https://github.com/schenkd/nginx-ui)

```yaml
version: '3'

services:
  nginx-ui:
    image: schenkd/nginx-ui:latest
    ports:
      - 8080:8080
    volumes:
      - nginx:/etc/nginx
```
## Feedback

If you have any feedback, please reach out to us at ekapon.chukaew@gmail.com

