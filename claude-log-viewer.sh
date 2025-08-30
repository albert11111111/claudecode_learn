#!/bin/bash

# ClaudeCode 聊天日志查看器
# 用于查看和管理Claude聊天日志

CHAT_LOG_DIR="/home/yrx20040502/finance/claude-chat-logs"
SUMMARY_LOG="$CHAT_LOG_DIR/chat-summary.log"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    echo -e "${CYAN}ClaudeCode 聊天日志查看器${NC}"
    echo -e "${YELLOW}用法: $0 [选项]${NC}"
    echo ""
    echo "选项:"
    echo "  -h, --help           显示此帮助信息"
    echo "  -l, --list           列出所有日志文件"
    echo "  -s, --summary        显示今日摘要"
    echo "  -t, --today          显示今日完整日志"
    echo "  -r, --recent [N]     显示最近N条记录 (默认20)"
    echo "  -f, --file [DATE]    显示指定日期的日志 (格式: YYYYMMDD)"
    echo "  -w, --watch          实时监控日志"
    echo "  -c, --clean [DAYS]   清理N天前的日志 (默认7天)"
    echo "  --stats              显示统计信息"
    echo ""
    echo "示例:"
    echo "  $0 -t                # 查看今日日志"
    echo "  $0 -r 50             # 查看最近50条记录"
    echo "  $0 -f 20250830       # 查看8月30日的日志"
    echo "  $0 -w                # 实时监控"
}

# 列出所有日志文件
list_logs() {
    echo -e "${CYAN}可用的日志文件:${NC}"
    if [ -d "$CHAT_LOG_DIR" ]; then
        ls -la "$CHAT_LOG_DIR"/*.log 2>/dev/null | while read line; do
            echo -e "${GREEN}$line${NC}"
        done
    else
        echo -e "${RED}日志目录不存在: $CHAT_LOG_DIR${NC}"
    fi
}

# 显示今日摘要
show_summary() {
    local today=$(date +%Y%m%d)
    local today_log="$CHAT_LOG_DIR/chat-${today}.log"
    
    echo -e "${CYAN}=== 今日活动摘要 ($(date +%Y-%m-%d)) ===${NC}"
    
    if [ -f "$SUMMARY_LOG" ]; then
        local today_pattern=$(date +%Y-%m-%d)
        grep "$today_pattern" "$SUMMARY_LOG" | tail -20 | while read line; do
            if [[ $line == *"工具:"* ]]; then
                echo -e "${BLUE}$line${NC}"
            elif [[ $line == *"文件操作:"* ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line == *"命令:"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo -e "${PURPLE}$line${NC}"
            fi
        done
    else
        echo -e "${RED}摘要日志不存在${NC}"
    fi
    
    # 显示统计信息
    if [ -f "$today_log" ]; then
        echo ""
        echo -e "${CYAN}今日统计:${NC}"
        echo -e "${GREEN}工具调用: $(grep -c "工具调用:" "$today_log")${NC}"
        echo -e "${GREEN}文件操作: $(grep -c "文件操作:" "$today_log")${NC}"
        echo -e "${GREEN}命令执行: $(grep -c "命令执行:" "$today_log")${NC}"
    fi
}

# 显示今日完整日志
show_today() {
    local today=$(date +%Y%m%d)
    local today_log="$CHAT_LOG_DIR/chat-${today}.log"
    
    echo -e "${CYAN}=== 今日完整日志 ($(date +%Y-%m-%d)) ===${NC}"
    
    if [ -f "$today_log" ]; then
        cat "$today_log" | while read line; do
            if [[ $line == *"==="* ]]; then
                echo -e "${CYAN}$line${NC}"
            elif [[ $line == *"工具调用:"* ]]; then
                echo -e "${BLUE}$line${NC}"
            elif [[ $line == *"文件操作:"* ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line == *"命令执行:"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo "$line"
            fi
        done
    else
        echo -e "${RED}今日日志文件不存在: $today_log${NC}"
    fi
}

# 显示最近的记录
show_recent() {
    local count=${1:-20}
    echo -e "${CYAN}=== 最近 $count 条记录 ===${NC}"
    
    if [ -f "$SUMMARY_LOG" ]; then
        tail -n "$count" "$SUMMARY_LOG" | while read line; do
            if [[ $line == *"工具:"* ]]; then
                echo -e "${BLUE}$line${NC}"
            elif [[ $line == *"文件操作:"* ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line == *"命令:"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            else
                echo -e "${PURPLE}$line${NC}"
            fi
        done
    else
        echo -e "${RED}摘要日志不存在${NC}"
    fi
}

# 显示指定日期的日志
show_date() {
    local date="$1"
    local log_file="$CHAT_LOG_DIR/chat-${date}.log"
    
    echo -e "${CYAN}=== 日志: $date ===${NC}"
    
    if [ -f "$log_file" ]; then
        cat "$log_file"
    else
        echo -e "${RED}指定日期的日志文件不存在: $log_file${NC}"
    fi
}

# 实时监控日志
watch_logs() {
    echo -e "${CYAN}=== 实时监控日志 (按Ctrl+C退出) ===${NC}"
    
    if [ -f "$SUMMARY_LOG" ]; then
        tail -f "$SUMMARY_LOG" | while read line; do
            timestamp=$(date '+%H:%M:%S')
            if [[ $line == *"工具:"* ]]; then
                echo -e "${BLUE}[$timestamp] $line${NC}"
            elif [[ $line == *"文件操作:"* ]]; then
                echo -e "${GREEN}[$timestamp] $line${NC}"
            elif [[ $line == *"命令:"* ]]; then
                echo -e "${YELLOW}[$timestamp] $line${NC}"
            else
                echo -e "${PURPLE}[$timestamp] $line${NC}"
            fi
        done
    else
        echo -e "${RED}摘要日志不存在，无法监控${NC}"
    fi
}

# 清理旧日志
clean_logs() {
    local days=${1:-7}
    echo -e "${CYAN}清理 $days 天前的日志文件...${NC}"
    
    if [ -d "$CHAT_LOG_DIR" ]; then
        find "$CHAT_LOG_DIR" -name "chat-*.log" -mtime +$days -type f | while read file; do
            echo -e "${YELLOW}删除: $file${NC}"
            rm -f "$file"
        done
        echo -e "${GREEN}清理完成${NC}"
    else
        echo -e "${RED}日志目录不存在${NC}"
    fi
}

# 显示统计信息
show_stats() {
    echo -e "${CYAN}=== 日志统计信息 ===${NC}"
    
    if [ -d "$CHAT_LOG_DIR" ]; then
        local log_count=$(find "$CHAT_LOG_DIR" -name "*.log" -type f | wc -l)
        local total_size=$(du -sh "$CHAT_LOG_DIR" 2>/dev/null | cut -f1)
        
        echo -e "${GREEN}日志文件数量: $log_count${NC}"
        echo -e "${GREEN}总占用空间: $total_size${NC}"
        
        if [ -f "$SUMMARY_LOG" ]; then
            echo -e "${GREEN}总记录数: $(wc -l < "$SUMMARY_LOG")${NC}"
            echo -e "${GREEN}今日记录数: $(grep "$(date +%Y-%m-%d)" "$SUMMARY_LOG" | wc -l)${NC}"
        fi
        
        echo -e "${CYAN}最近的日志文件:${NC}"
        ls -lt "$CHAT_LOG_DIR"/*.log 2>/dev/null | head -5
    else
        echo -e "${RED}日志目录不存在${NC}"
    fi
}

# 主程序
case "$1" in
    -h|--help)
        show_help
        ;;
    -l|--list)
        list_logs
        ;;
    -s|--summary)
        show_summary
        ;;
    -t|--today)
        show_today
        ;;
    -r|--recent)
        show_recent "$2"
        ;;
    -f|--file)
        if [ -z "$2" ]; then
            echo -e "${RED}请指定日期 (格式: YYYYMMDD)${NC}"
            exit 1
        fi
        show_date "$2"
        ;;
    -w|--watch)
        watch_logs
        ;;
    -c|--clean)
        clean_logs "$2"
        ;;
    --stats)
        show_stats
        ;;
    "")
        show_summary
        ;;
    *)
        echo -e "${RED}未知选项: $1${NC}"
        show_help
        exit 1
        ;;
esac
