#!/bin/bash

# ClaudeCode 备份脚本
# 用于在编辑前备份文件

BACKUP_DIR="/home/yrx20040502/finance/claude-backups/"
LOG_FILE="/home/yrx20040502/finance/claude-backup.log"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 记录开始时间
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "$TIMESTAMP - 备份开始" >> "$LOG_FILE"
echo "$TIMESTAMP - 参数1: $1, 参数2: $2" >> "$LOG_FILE"
echo "$TIMESTAMP - 环境变量TARGET_FILE: $TARGET_FILE" >> "$LOG_FILE"
echo "$TIMESTAMP - 环境变量FILE: $FILE" >> "$LOG_FILE"
echo "$TIMESTAMP - 当前工作目录: $(pwd)" >> "$LOG_FILE"

# 尝试获取目标文件路径
# 首先尝试第一个参数（通过 hook 传递）
TARGET_FILE="$1"

# 如果没有，通过第二个参数
if [ -z "$TARGET_FILE" ]; then
    TARGET_FILE="$2"
fi

# 如果还是没有，尝试从环境变量获取
if [ -z "$TARGET_FILE" ] && [ -n "$TARGET_FILE_ENV" ]; then
    TARGET_FILE="$TARGET_FILE_ENV"
fi

# 如果还是没有，尝试其他可能的变量
if [ -z "$TARGET_FILE" ] && [ -n "$FILE" ]; then
    TARGET_FILE="$FILE"
fi

# 如果还是没有，尝试获取最近修改的文件
if [ -z "$TARGET_FILE" ]; then
    # 查找最近1分钟内修改的文件
    TARGET_FILE=$(find . -maxdepth 2 \( -name "*.py" -o -name "*.java" -o -name "*.js" -o -name "*.ts" -o -name "*.txt" -o -name "*.md" \) -type f -mmin -1 2>/dev/null | head -1)
    if [ -n "$TARGET_FILE" ]; then
        echo "$TIMESTAMP - 通过最近修改时间找到文件: $TARGET_FILE" >> "$LOG_FILE"
    fi
fi

# 如果还是没有，尝试从当前目录获取最近修改的任何文件
if [ -z "$TARGET_FILE" ]; then
    TARGET_FILE=$(find . -maxdepth 1 -type f -mmin -1 2>/dev/null | grep -v "\.bak$" | grep -v "\.log$" | head -1)
    if [ -n "$TARGET_FILE" ]; then
        echo "$TIMESTAMP - 通过通用搜索找到文件: $TARGET_FILE" >> "$LOG_FILE"
    fi
fi

# 如果还是没有，尝试从当前工作目录的文件获取（可能不准确）
if [ -z "$TARGET_FILE" ]; then
    # 这里可以根据您的具体情况调整
    # 例如，如果总是编辑特定类型的文件，可以在这里指定
    echo "$TIMESTAMP - 无法确定目标文件路径" >> "$LOG_FILE"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
    echo "$TIMESTAMP - 文件不存在: $TARGET_FILE" >> "$LOG_FILE"
    exit 1
fi

# 生成备份文件名
BASENAME=$(basename "$TARGET_FILE")
DATETIME=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}${BASENAME}.${DATETIME}.bak"

# 执行备份
if cp "$TARGET_FILE" "$BACKUP_FILE"; then
    echo "$TIMESTAMP - 备份成功: $TARGET_FILE -> $BACKUP_FILE" >> "$LOG_FILE"
    echo "备份已创建: $BACKUP_FILE"
else
    echo "$TIMESTAMP - 备份失败: $TARGET_FILE" >> "$LOG_FILE"
    exit 1
fi
