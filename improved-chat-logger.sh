#!/bin/bash

# 改进的ClaudeCode对话记录脚本
# 处理对话内容和工具调用的完整记录

CHAT_LOG_DIR="/home/yrx20040502/finance/claude-chat-logs"
CHAT_LOG_FILE="$CHAT_LOG_DIR/chat-$(date +%Y%m%d).log"
SUMMARY_LOG="$CHAT_LOG_DIR/chat-summary.log"

# 创建日志目录
mkdir -p "$CHAT_LOG_DIR"

# 获取当前时间戳
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 函数：记录工具调用（包括参数和结果）
log_tool_call() {
    local tool_name="$1"
    local tool_input="$2"
    local tool_output="$3"
    
    echo "=== [$TIMESTAMP] 工具调用: $tool_name ===" >> "$CHAT_LOG_FILE"
    echo "工具输入:" >> "$CHAT_LOG_FILE"
    echo "$tool_input" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    echo "工具输出:" >> "$CHAT_LOG_FILE"
    echo "$tool_output" | head -c 1000 >> "$CHAT_LOG_FILE"  # 限制输出长度
    [ ${#tool_output} -gt 1000 ] && echo "...（输出已截断）" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    echo "---" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
}

# 函数：记录对话内容
log_conversation() {
    local user_input="$1"
    local ai_response="$2"
    
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "[$TIMESTAMP] 用户:" >> "$CHAT_LOG_FILE"
    echo "$user_input" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    echo "[$TIMESTAMP] AI:" >> "$CHAT_LOG_FILE"
    echo "$ai_response" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
    
    # 更新摘要
    echo "$TIMESTAMP - 对话记录: 用户提问${#user_input}字符, AI回复${#ai_response}字符" >> "$SUMMARY_LOG"
}

# 函数：记录文件操作
log_file_operation() {
    local operation="$1"
    local file_path="$2"
    local description="$3"
    
    echo "=== [$TIMESTAMP] 文件操作: $operation ===" >> "$CHAT_LOG_FILE"
    echo "文件: $file_path" >> "$CHAT_LOG_FILE"
    echo "描述: $description" >> "$CHAT_LOG_FILE"
    
    if [ -f "$file_path" ]; then
        echo "文件大小: $(wc -l < "$file_path") 行" >> "$CHAT_LOG_FILE"
        echo "最后修改: $(stat -c %y "$file_path")" >> "$CHAT_LOG_FILE"
    fi
    echo "" >> "$CHAT_LOG_FILE"
}

# 函数：记录命令执行
log_command() {
    local command="$1"
    local exit_code="$2"
    local output="$3"
    
    echo "=== [$TIMESTAMP] 命令执行 ===" >> "$CHAT_LOG_FILE"
    echo "命令: $command" >> "$CHAT_LOG_FILE"
    echo "退出码: $exit_code" >> "$CHAT_LOG_FILE"
    echo "输出:" >> "$CHAT_LOG_FILE"
    echo "$output" | head -c 500 >> "$CHAT_LOG_FILE"
    [ ${#output} -gt 500 ] && echo "...（输出已截断）" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
}

# 函数：记录会话开始
log_session_start() {
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "=== 新会话开始: $TIMESTAMP ===" >> "$CHAT_LOG_FILE"
    echo "工作目录: $(pwd)" >> "$CHAT_LOG_FILE"
    echo "环境: $(uname -a)" >> "$CHAT_LOG_FILE"
    echo "=================================" >> "$CHAT_LOG_FILE"
    echo "" >> "$CHAT_LOG_FILE"
}

# 主处理逻辑
case "$1" in
    "session_start")
        log_session_start
        ;;
    "conversation")
        log_conversation "$2" "$3"
        ;;
    "tool")
        log_tool_call "$2" "$3" "$4"
        ;;
    "file")
        log_file_operation "$2" "$3" "$4"
        ;;
    "command")
        log_command "$2" "$3" "$4"
        ;;
    *)
        echo "=== [$TIMESTAMP] 其他事件 ===" >> "$CHAT_LOG_FILE"
        echo "事件: $1" >> "$CHAT_LOG_FILE"
        echo "参数: ${@:2}" >> "$CHAT_LOG_FILE"
        echo "" >> "$CHAT_LOG_FILE"
        ;;
esac