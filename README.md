# 资产导入工作流服务

一个用于批量处理资产导入、区块链存证和Excel生成的Python应用程序，支持在私有云环境中以容器化方式部署。

## 功能特性

- **区块链存证**：将资产信息提交到区块链进行存证
- **Excel处理**：读取和生成符合规范的Excel文件
- **库存导入**：将处理后的Excel文件上传至库存系统
- **环境变量配置**：支持通过环境变量灵活配置服务参数
- **容错机制**：包含重试机制和错误处理
- **日志记录**：详细的日志记录便于调试和监控

## 环境变量配置

创建 `.env` 文件来配置服务参数：

```bash
# 区块链存证服务配置
EVIDENCE_BASE_URL=http://172.22.152.154:8090
CHAIN_ID=FELGN5IWTZB4

# 存证服务认证信息
EVIDENCE_API_KEY=your_api_key
EVIDENCE_IDENTITY_ID=your_identity_id
EVIDENCE_COOKIE=Secure

# 库存导入服务配置
INVENTORY_BASE_URL=http://47.92.193.45:31880
INVENTORY_TOKEN=your_jwt_token

# 应用配置
OUTPUT_DIR=./output
BATCH_SIZE=10
REQUEST_TIMEOUT=30
MAX_RETRIES=3
LOG_LEVEL=INFO

# 输入文件配置
INPUT_DIR=./input
INPUT_FILE=test.xlsx
```

## 部署方式

### Docker Compose 部署（推荐）

```bash
# 构建并启动服务
docker-compose up -d

# 或者使用自定义环境变量文件
docker-compose --env-file .env up -d
```

### 直接运行 Docker

```bash
# 构建镜像
docker build -t asset-import-service .

# 运行容器
docker run -d \
  --name asset-import-service \
  -e EVIDENCE_BASE_URL=http://your-evidence-service:8090 \
  -e INVENTORY_BASE_URL=http://your-inventory-service:31880 \
  -v ./input:/app/input:ro \
  -v ./output:/app/output:rw \
  asset-import-service
```

### 本地运行

```bash
# 安装依赖
pip install -r requirements.txt

# 运行应用
python app/main.py --file test.xlsx
```

## 使用方法

1. 准备输入的Excel文件，放置在 `input` 目录中
2. 配置好环境变量
3. 启动服务后，程序会自动处理Excel文件
4. 处理完成后，在 `output` 目录中查看生成的Excel文件

## 项目结构

```
/workspace/
├── app/
│   └── main.py          # 主应用文件
├── Dockerfile           # Docker构建文件
├── docker-compose.yml   # Docker Compose配置
├── requirements.txt     # Python依赖
├── .env.example         # 环境变量示例
└── README.md            # 项目说明文档
```

## 私有云部署建议

1. **安全性**：不要将敏感信息（如API密钥、JWT令牌）硬编码在配置文件中
2. **持久化存储**：挂载外部卷来保存输入/输出文件
3. **监控与日志**：集成日志收集系统以便监控应用状态
4. **网络配置**：确保容器能够访问所需的外部服务
5. **资源限制**：根据实际需求设置CPU和内存限制

## 故障排除

- 检查网络连接：确保容器可以访问存证和库存服务
- 查看日志：使用 `docker logs asset-import-service` 查看详细日志
- 验证权限：确保挂载的目录具有适当的读写权限
- 检查环境变量：确认所有必需的环境变量都已正确设置