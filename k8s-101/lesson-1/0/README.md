# Docker Intro

```bash
docker build -t custom-nginx:latest .
docker run --rm -ti -p 8080:80 custom-nginx:latest

curl localhost:8080
```
