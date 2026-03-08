#!/bin/bash

# 项目状态追踪脚本
PROJECT_ROOT="$(pwd)"
STATE_FILE="$PROJECT_ROOT/.guide_state"
HISTORY_FILE="$PROJECT_ROOT/.guide_history"

# 自动检测项目阶段
detect_stage() {
    local has_code=false
    local has_tests=false

    # 检查是否已初始化
    if [ ! -f "$PROJECT_ROOT/config/env.json" ]; then
        echo "init"
        return
    fi

    # 检查是否有设计文档
    if [ ! -d "$PROJECT_ROOT/docs/plans" ] || [ -z "$(ls -A $PROJECT_ROOT/docs/plans 2>/dev/null)" ]; then
        echo "planning"
        return
    fi

    # 检查是否有代码
    if [ -d "$PROJECT_ROOT/src" ]; then
        if [ -n "$(find $PROJECT_ROOT/src -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rb' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.html' -o -name '*.css' -o -name '*.vue' -o -name '*.svelte' \) 2>/dev/null)" ]; then
            has_code=true
        fi
    fi

    # 检查是否有测试
    if [ -d "$PROJECT_ROOT/tests" ] && [ -n "$(ls -A $PROJECT_ROOT/tests 2>/dev/null)" ]; then
        has_tests=true
    fi

    # 根据代码和测试情况决定阶段
    if [ "$has_code" = true ]; then
        if [ "$has_tests" = true ]; then
            cd "$PROJECT_ROOT"
            if git remote -v 2>/dev/null | grep -q origin; then
                echo "completed"
            else
                echo "ready"
            fi
        else
            cd "$PROJECT_ROOT"
            if git remote -v 2>/dev/null | grep -q origin; then
                echo "verify"
            else
                echo "testing"
            fi
        fi
        return
    fi

    # 没有代码
    if [ ! -f "$PROJECT_ROOT/.todos" ] || [ -z "$(cat $PROJECT_ROOT/.todos 2>/dev/null)" ]; then
        echo "tasks"
    else
        echo "development"
    fi
}

# 获取活动描述
get_activity() {
    local stage="$1"
    case "$stage" in
        "init") echo "项目初始化" ;;
        "planning") echo "需求分析和设计" ;;
        "tasks") echo "任务规划" ;;
        "development") echo "开发中" ;;
        "testing") echo "代码已写完，等待测试" ;;
        "verify") echo "待验证和上传" ;;
        "ready") echo "准备就绪，等待推送" ;;
        "completed") echo "已完成并推送到远程" ;;
        *) echo "未知活动" ;;
    esac
}

update_state() {
    local stage="$1"
    local activity="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # 如果没有提供 stage，自动检测
    if [ -z "$stage" ]; then
        stage=$(detect_stage)
    fi

    # 如果没有提供 activity，自动获取
    if [ -z "$activity" ]; then
        activity=$(get_activity "$stage")
    fi

    # 追加历史记录
    echo "[$timestamp] $stage - $activity" >> "$HISTORY_FILE"

    # 更新当前状态（覆盖）
    echo "CURRENT_STAGE=\"${stage}\"" > "$STATE_FILE"
    echo "LAST_ACTIVITY=\"${activity}\"" >> "$STATE_FILE"

    echo "✓ 状态已更新：$stage - $activity"
    echo "✓ 历史记录已追加"
}

show_state() {
    if [ -f "$STATE_FILE" ]; then
        local stage activity
        stage=$(grep "CURRENT_STAGE=" "$STATE_FILE" | cut -d'"' -f2)
        activity=$(grep "LAST_ACTIVITY=" "$STATE_FILE" | cut -d'"' -f2)
        echo "当前阶段：${stage:-未知}"
        echo "最后活动：${activity:-无}"
        echo ""

        # 显示历史记录
        if [ -f "$HISTORY_FILE" ]; then
            echo "════════════════════════════════════════════════════════"
            echo "  历史活动记录"
            echo "════════════════════════════════════════════════════════"
            echo ""
            tail -10 "$HISTORY_FILE" | while read line; do
                echo "  $line"
            done
            echo ""
        fi
    else
        echo "项目未初始化"
    fi
}

show_history() {
    if [ -f "$HISTORY_FILE" ]; then
        echo "════════════════════════════════════════════════════════"
        echo "  完整活动历史"
        echo "════════════════════════════════════════════════════════"
        echo ""
        cat "$HISTORY_FILE"
        echo ""
    else
        echo "无历史记录"
    fi
}

case "${1:-show}" in
    "update") update_state "$2" "$3" ;;
    "show") show_state ;;
    "history") show_history ;;
    *) echo "用法：$0 {show|history|update <stage> <activity>}"; exit 1 ;;
esac