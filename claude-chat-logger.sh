#!/bin/bash

# ClaudeCode 聊天日志记录脚本
# 记录与Claude的所有交互内容

CHAT_LOG_DIR="/home/yrx20040502/finance/claude-chat-logs"
CHAT_LOG_FILE="$CHAT_LOG_DIR/chat-$(date +%Y%m%d).log"
SUMMARY_LOG="$CHAT_LOG_DIR/chat-summary.log"

# 创建日志目录
mkdir -p "$CHAT_LOG_DIR"

# 获取当前时间戳
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 函数：记录工具使用
log_tool_use() {
    local tool_name="$1"
    local tool_input="$2"
    local session_id=$(date +%s)
    
    echo "=== [$TIMESTAMP] 工具调用: $tool_name ===" >> "$CHAT_LOG_FILE"
    echo "会话ID: $session_id" >> "$CHAT_LOG_FILE"
    echo "工具输入: $tool_input" >> "$CHAT_LOG_FILE"
    echo "工作目录: $(pwd)" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    
    # 更新摘要日志
    echo "$TIMESTAMP - 工具: $tool_name" >> "$SUMMARY_LOG"
}

# 函数：记录文件操作
log_file_operation() {
    local operation="$1"
    local file_path="$2"
    
    echo "=== [$TIMESTAMP] 文件操作: $operation ===" >> "$CHAT_LOG_FILE"
    echo "文件路径: $file_path" >> "$CHAT_LOG_FILE"
    echo "操作类型: $operation" >> "$CHAT_LOG_FILE"
    
    # 如果是读取操作，记录文件大小
    if [ "$operation" = "read" ] && [ -f "$file_path" ]; then
        echo "文件大小: $(wc -l < "$file_path") 行" >> "$CHAT_LOG_FILE"
    fi
    
    # 如果是写入/编辑操作，记录文件状态
    if [[ "$operation" =~ ^(write|edit|search_replace)$ ]] && [ -f "$file_path" ]; then
        echo "文件大小: $(wc -l < "$file_path") 行" >> "$CHAT_LOG_FILE"
        echo "最后修改: $(stat -c %y "$file_path")" >> "$CHAT_LOG_FILE"
    fi
    
    echo "" >> "$CHAT_LOG_FILE"
    
    # 更新摘要日志
    echo "$TIMESTAMP - 文件操作: $operation - $file_path" >> "$SUMMARY_LOG"
}

# 函数：记录命令执行
log_command() {
    local command="$1"
    
    echo "=== [$TIMESTAMP] 命令执行 ===" >> "$CHAT_LOG_FILE"
    echo "命令: $command" >> "$CHAT_LOG_FILE"
    echo "工作目录: $(pwd)" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    
    # 更新摘要日志
    echo "$TIMESTAMP - 命令: $command" >> "$SUMMARY_LOG"
}

# 函数：记录会话开始
log_session_start() {
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "=== 新会话开始: $TIMESTAMP ===" >> "$CHAT_LOG_FILE"
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
}

# 函数：记录对话内容
log_conversation() {
    local user_prompt="$1"
    local ai_response="$2"
    
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "[$TIMESTAMP] 用户:" >> "$CHAT_LOG_FILE"
    echo "$user_prompt" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    echo "[$TIMESTAMP] AI:" >> "$CHAT_LOG_FILE"
    echo "$ai_response" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    
    # 更新摘要日志
    echo "$TIMESTAMP - 对话记录: 用户提问已记录" >> "$SUMMARY_LOG"
}

# 根据传入的参数决定记录类型
case "$1" in
    "tool")
        log_tool_use "$2" "$3"
        ;;
    "file")
        log_file_operation "$2" "$3"
        ;;
    "command")
        log_command "$2"
        ;;
    "conversation")
        log_conversation "$2" "$3"
        ;;
    "session")
        log_session_start
        ;;
    *)
        # 默认记录一般交互
        echo "=== [$TIMESTAMP] Claude交互 ===" >> "$CHAT_LOG_FILE"
        echo "参数: $*" >> "$CHAT_LOG_FILE"
        echo "环境: WSL $(uname -r)" >> "$CHAT_LOG_FILE"
        echo "" >> "$CHAT_LOG_FILE"
        ;;
esac

# 保持日志文件大小合理（可选）
if [ -f "$CHAT_LOG_FILE" ] && [ $(wc -l < "$CHAT_LOG_FILE") -gt 10000 ]; then
    # 备份当前日志
    mv "$CHAT_LOG_FILE" "${CHAT_LOG_FILE}.backup.$(date +%H%M%S)"
    echo "=== 日志文件已备份并重新开始 ===" > "$CHAT_LOG_FILE"
fi
