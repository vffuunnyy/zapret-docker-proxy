# Zapret-Proxy Setup

This repository provides an automated way to set up a proxy server with traffic filtering using Squid and Zapret. 
The script `quickstart.sh` simplifies the process by installing dependencies, configuring the environment, and launching the Docker container.

## **Quickstart**

### **1. Clone the Repository**
Clone this repository to your machine:

```bash
git clone https://github.com/8hrsk/zapret-docker-proxy.git
cd zapret-docker-proxy
```

### **2. Add Zapret Configuration**
Place your custom configuration for Zapret in the cloned repository's folder:

```bash
cp /path/to/your/zapret/config ./config
```

### **3. Run the Quickstart Script**
The `quickstart.sh` script will automatically download bol-van/zapret (69.8), build and start the Docker container:

```bash
./quickstart.sh
```

### **4. Configure Port Forwarding**
If you are **not running the container on a VPS or dedicated server**, you need to configure port forwarding on your router:

1. Log in to your router's admin panel.
2. Forward port `3128` to the local IP address of the machine running the container.

   Example:
   - Local IP: `192.168.1.100`
   - Port: `3128`

3. Save and apply the changes.

### **5. Set Up Proxy on Your Device**
Configure your device to use the proxy:

- **Proxy Address**: Use the local address of your machine (e.g., `192.168.1.100`).
- **Proxy Port**: `3128`

For example, in a browser, configure the proxy settings to use `http://192.168.1.100:3128`.

---

## **Manual Docker Commands**
If you prefer manual control, use the following commands:

### Build the Container
```bash
docker-compose build
```

### Start the Container
```bash
docker-compose up -d
```

### Access the Logs
```bash
docker logs -f zapret-proxy
```

### Stop the Container
```bash
docker-compose down
```

---

## **Troubleshooting**

### Squid Issues
- Ensure your Zapret configuration is valid.
- Check Docker logs for errors:
  ```bash
  docker logs zapret-proxy
  ```

### Port Forwarding Issues
- Verify that your router forwards port `3128` to the correct local IP.
- Confirm that no firewall rules are blocking the forwarded port.

---

## **Contributing**
Feel free to submit issues or pull requests to improve the project.
I would be very happy if you help me integrate iptables support, because I do not have necessary knowledge <3

---

## **License**
This project is licensed under the MIT License.
