# 🚀 Express API Load Balancing & Autoscaling (Docker Swarm on Raspberry Pi)

This project is designed to experiment with **load balancing** and **autoscaling** using:

- Express.js API
- Docker Swarm
- Raspberry Pi as a home server
- Cron-based autoscaling scripts
- CPU-based scaling logic

Its main goal is to help understand real-world DevOps concepts such as:

- Service replication
- Load balancing (Round Robin)
- Horizontal scaling
- Autoscaling logic
- Cron automation
- CPU load testing

---

## 📦 Project Overview

This project starts a **Docker Swarm service with three Express API replicas**.
Swarm's built-in load balancer automatically distributes requests across replicas.

You can test this by:

- Opening multiple browser tabs
- Calling the `/` endpoint
- Observing that each page load may hit a different replica

Sometimes you must open a **new tab**, because browsers reuse existing connections.

This confirms that **Swarm’s load balancer is working correctly**.

---

## 🔥 Autoscaling with Cron (CPU-based)

A custom `autoscale.sh` script checks the CPU usage of the service and:

- Scales **UP** by +1 replica when CPU > 35%
- Scales **DOWN** by –1 replica when CPU < 20%
- Ensures replica count stays within the configured MIN and MAX

To enable autoscaling, add these lines at the top of `crontab -e`:

```bash
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

* * * * * /var/www/express-load-test/autoscale.sh >> /home/davide/logs/autoscale.log 2>&1
```
To disable autoscaling, simply:

- Comment out the cron line
- Or remove it entirely

---

## 📁 autoscale.sh (included)

The autoscaler uses:

- Docker Swarm replicas count
- `docker stats` CPU percentage parsing
- `bc` for floating-point comparison
- Smooth scaling: +1 or –1 replica at a time

---

## 🖥️ Testing the Load Balancer

Once the service is running:

```bash
docker stack deploy -c docker-compose.yml loadtest
```

Open several new browser tabs:


Each refresh (or new tab) may show a different container ID, proving:

- ✔ Docker Swarm's load balancer
- ✔ Round-robin request routing
- ✔ Multiple replicas serving traffic

---

## 🧪 For CPU Load Testing

You can stress the service using:

### ApacheBench:
```bash
ab -n 200 -c 20 http://YOUR_PI_IP:3003/cpu

OR

 while true; do curl -s http://192.168.0.20:3003/cpu > /dev/null; done

```

This will trigger autoscaling when CPU usage rises above the configured threshold.

---

## 🧰 Requirements

- Raspberry Pi (running Raspberry Pi OS or Debian/Ubuntu)
- Docker Engine 20+
- Docker Swarm initialized
- Node.js (only for local development)
- `bc` installed for autoscaling script

---

## 🧭 Project Purpose

The purpose of this project is to:

- Understand Docker Swarm orchestration
- Learn and visualize horizontal scaling
- Practice building autoscaling systems
- Test on a real Raspberry Pi home server
- Build foundational DevOps knowledge
  *(applicable to AWS, GCP, Azure, Kubernetes, ECS, etc.)*

---

## 📝 License

This project is licensed under the **MIT License**.

---

## 👤 Maintainer

Project maintained by **Davide Castelli**.
Feel free to reach out with questions, suggestions, or ideas.
Happy coding! 🚀
