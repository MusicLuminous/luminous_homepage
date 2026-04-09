# 悠悠个人主页 Docker 部署指南（使用现有 OpenResty）

## 部署准备

### 环境要求
- Docker
- OpenResty（已安装）
- 服务器（推荐 1GB 内存以上）

### 项目文件结构
```
youyou-main/
├── backend/            # 后端代码
├── frontend/           # 前台代码
├── admin/              # 后台管理
├── install/            # 安装向导
├── deploy/             # 部署脚本
├── Dockerfile          # 应用服务镜像构建文件
└── DEPLOY.md           # 部署指南
```

## 部署步骤

### 步骤 1：上传项目文件
将整个项目目录上传到服务器，例如：`/opt/youyou-main`

### 步骤 2：进入项目目录
```bash
cd /opt/youyou-main
```

### 步骤 3：构建 Docker 镜像
```bash
docker build -t youyou-homepage .
```

### 步骤 4：运行容器
```bash
# 启动容器（后台运行）
docker run -d \
  --name youyou-homepage \
  -p 3000:3000 \
  -v $(pwd)/backend/data:/app/backend/data \
  youyou-homepage
```

### 步骤 5：验证服务状态
```bash
# 查看容器状态
docker ps

# 查看应用日志
docker logs -f youyou-homepage
```

### 步骤 6：配置 OpenResty 反向代理
编辑 OpenResty 配置文件（通常位于 `/usr/local/openresty/nginx/conf/nginx.conf` 或 `/etc/nginx/nginx.conf`），添加以下配置：

```nginx
server {
    listen 80;
    server_name your-domain.com;  # 替换为你的域名或服务器IP

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 步骤 7：重启 OpenResty
```bash
sudo systemctl restart openresty
# 或
sudo /usr/local/openresty/nginx/sbin/nginx -s reload
```

### 步骤 8：完成安装
访问 `http://服务器IP` 或 `http://你的域名`，按安装向导完成配置。

## 访问方式
- 前台：`http://服务器IP` 或 `http://你的域名`
- 后台管理：`http://服务器IP/admin` 或 `http://你的域名/admin`
- 安装向导：`http://服务器IP/install` 或 `http://你的域名/install`（首次访问时）

## 配置选项

### 1. 使用 MySQL 数据库
```bash
# 启动 MySQL 容器
docker run -d \
  --name youyou-mysql \
  -e MYSQL_ROOT_PASSWORD=your_password \
  -e MYSQL_DATABASE=personal_homepage \
  -v mysql-data:/var/lib/mysql \
  mysql:5.7

# 启动应用容器（连接 MySQL）
docker run -d \
  --name youyou-homepage \
  -p 3000:3000 \
  -v $(pwd)/backend/data:/app/backend/data \
  -e DB_HOST=youyou-mysql \
  -e DB_PORT=3306 \
  -e DB_USER=root \
  -e DB_PASSWORD=your_password \
  -e DB_NAME=personal_homepage \
  -e DB_PREFIX=hp_ \
  --link youyou-mysql:mysql \
  youyou-homepage
```

### 2. 配置 HTTPS
1. 准备 SSL 证书，将证书文件放置在 OpenResty 的证书目录（例如 `/etc/ssl/certs/`）
2. 编辑 OpenResty 配置文件，添加 HTTPS 配置：
   ```nginx
   server {
       listen 443 ssl;
       server_name your-domain.com;  # 替换为你的域名
       
       ssl_certificate /etc/ssl/certs/fullchain.pem;  # 替换为证书路径
       ssl_certificate_key /etc/ssl/certs/privkey.pem;  # 替换为私钥路径
       
       location / {
           proxy_pass http://127.0.0.1:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_cache_bypass $http_upgrade;
       }
   }
   
   # 重定向 HTTP 到 HTTPS
   server {
       listen 80;
       server_name your-domain.com;  # 替换为你的域名
       return 301 https://$host$request_uri;
   }
   ```
3. 重启 OpenResty：
   ```bash
   sudo systemctl restart openresty
   # 或
   sudo /usr/local/openresty/nginx/sbin/nginx -s reload
   ```

## 数据持久化
- **JSON 模式**：数据存储在 `backend/data` 目录，已通过卷挂载到宿主机
- **MySQL 模式**：数据存储在 MySQL 容器中

## 常用命令

### 容器管理
```bash
# 启动容器
docker start youyou-homepage

# 停止容器
docker stop youyou-homepage

# 重启容器
docker restart youyou-homepage

# 查看容器状态
docker ps

# 查看日志
docker logs -f youyou-homepage

# 进入容器
docker exec -it youyou-homepage sh

# 删除容器
docker rm -f youyou-homepage
```

### 镜像管理
```bash
# 查看镜像
docker images

# 删除镜像
docker rmi youyou-homepage

# 重新构建镜像
docker build -t youyou-homepage .
```

### OpenResty 管理
```bash
# 查看 OpenResty 日志
tail -f /usr/local/openresty/nginx/logs/error.log

# 测试 OpenResty 配置
sudo /usr/local/openresty/nginx/sbin/nginx -t

# 重启 OpenResty
sudo systemctl restart openresty
# 或
sudo /usr/local/openresty/nginx/sbin/nginx -s reload
```

## 故障排查

### 1. 容器无法启动
- 检查容器日志：`docker logs youyou-homepage`
- 检查端口占用：`netstat -tulpn | grep 3000`
- 检查 Docker 服务状态：`systemctl status docker`

### 2. 访问 502 错误
- 检查容器是否正常运行：`docker ps`
- 检查容器日志：`docker logs youyou-homepage`
- 检查 OpenResty 配置是否正确

### 3. 数据备份
```bash
# JSON 模式：备份数据目录
cp -r /opt/youyou-main/backend/data ./backup/
```

## 注意事项
1. **安全配置**：
   - 修改默认管理员密码
   - 如使用 MySQL，设置强密码
   - 生产环境建议配置 HTTPS

2. **更新部署**：
   ```bash
   # 停止并删除旧容器
   docker stop youyou-homepage
   docker rm youyou-homepage
   
   # 重新构建镜像
   docker build -t youyou-homepage .
   
   # 启动新容器
   docker run -d \
     --name youyou-homepage \
     -p 3000:3000 \
     -v $(pwd)/backend/data:/app/backend/data \
     youyou-homepage
   ```

## 部署完成

部署完成后，你可以：
1. 访问 `http://服务器IP` 查看前台页面
2. 访问 `http://服务器IP/admin` 进入后台管理（默认账号：admin/123456）
3. 根据实际需求配置网站信息、添加个人标签、设置外链等

祝你使用愉快！
