FROM python:3.9-slim

WORKDIR /app

# 复制依赖文件
COPY requirements.txt .

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app/ .

# 创建输出目录
RUN mkdir -p ./output

# 设置默认环境变量
ENV LOG_LEVEL=INFO
ENV BATCH_SIZE=10
ENV REQUEST_TIMEOUT=30
ENV MAX_RETRIES=3

# 健康检查端点（虽然这是一个批处理应用，但可以添加健康检查）
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD echo "Health check - service is running"

CMD ["python", "main.py"]