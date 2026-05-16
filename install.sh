#!/usr/bin/env bash
set -euo pipefail

# Skills 多平台安装脚本
# 自动检测已安装的 AI 工具，一键全量安装
# 用法: bash scripts/install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(dirname "$SCRIPT_DIR")/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${CYAN}[*]${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}[+]${RESET} %s\n" "$*"; }
warn()  { printf "${YELLOW}[!]${RESET} %s\n" "$*"; }
fail()  { printf "${RED}[x]${RESET} %s\n" "$*"; exit 1; }

# === 平台检测 ===

detect_tools() {
    local tools=()
    [ -d "$HOME/.claude" ] && tools+=("claude")
    [ -d "$HOME/.kimi" ] && tools+=("kimi")
    [ -d "$HOME/.codex" ] && tools+=("codex")
    [ -d "$HOME/.codebuddy" ] && tools+=("codebuddy")
    printf '%s\n' "${tools[@]}"
}

tool_name() {
    case "$1" in
        claude) echo "Claude Code" ;;
        kimi) echo "Kimi Code CLI" ;;
        codex) echo "OpenAI Codex" ;;
        codebuddy) echo "CodeBuddy" ;;
        *) echo "$1" ;;
    esac
}

tool_global_dir() {
    case "$1" in
        claude) echo "$HOME/.claude/skills" ;;
        kimi) echo "$HOME/.kimi/skills" ;;
        codex) echo "$HOME/.codex/skills" ;;
        codebuddy) echo "$HOME/.codebuddy/skills" ;;
    esac
}

# === 安装逻辑 ===

install_skill_to() {
    local src_dir="$1"
    local dest_base="$2"
    local skill_name=$(basename "$src_dir")
    local cat_name=$(basename "$(dirname "$src_dir")")
    local dest_dir="$dest_base/$cat_name/$skill_name"

    mkdir -p "$dest_dir"
    cp -r "$src_dir"/* "$dest_dir/"
    ok "  → $cat_name/$skill_name"
}

install_all_to() {
    local dest_base="$1"
    find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort | while read -r cat_dir; do
        local cat_name=$(basename "$cat_dir")
        find "$cat_dir" -mindepth 1 -maxdepth 1 -type d | sort | while read -r skill_dir; do
            if [ -f "$skill_dir/SKILL.md" ]; then
                install_skill_to "$skill_dir" "$dest_base"
            fi
        done
    done
}

count_skills() {
    find "$SKILLS_DIR" -name "SKILL.md" -type f | wc -l
}

# === Kimi 配置 ===

configure_kimi() {
    local config_file="$HOME/.kimi/config.toml"
    if [ ! -f "$config_file" ]; then
        warn "  未找到 Kimi 配置文件: $config_file"
        return
    fi

    info "  配置 Kimi Code CLI..."

    # 设置 merge_all_available_skills = true
    if grep -q "^merge_all_available_skills" "$config_file"; then
        sed -i 's/^merge_all_available_skills[[:space:]]*=.*/merge_all_available_skills = true/' "$config_file"
    else
        sed -i '1i\merge_all_available_skills = true' "$config_file"
    fi

    # 设置 extra_skill_dirs
    local dirs='["~/.kimi/skills", "~/.claude/skills"]'
    if grep -q "^extra_skill_dirs" "$config_file"; then
        sed -i "s#^extra_skill_dirs[[:space:]]*=.*#extra_skill_dirs = $dirs#" "$config_file"
    else
        sed -i "/^merge_all_available_skills/a\\extra_skill_dirs = $dirs" "$config_file"
    fi

    ok "  Kimi 配置已更新"
}

# === 主流程 ===

main() {
    echo ""
    echo "====================== Skills 安装工具 ======================"
    echo ""

    # 检测平台
    local detected=()
    while IFS= read -r t; do
        detected+=("$t")
    done < <(detect_tools)

    if [ ${#detected[@]} -eq 0 ]; then
        warn "未检测到任何 AI 编程工具"
        echo ""
        echo "支持的安装目标:"
        echo "  ~/.claude/skills     (Claude Code)"
        echo "  ~/.kimi/skills       (Kimi Code CLI)"
        echo "  ~/.codex/skills      (OpenAI Codex)"
        echo "  ~/.codebuddy/skills  (CodeBuddy)"
        echo ""
        fail "请至少安装一个支持的 AI 工具后再运行此脚本"
    fi

    # 显示检测到的平台
    info "检测到以下工具:"
    for t in "${detected[@]}"; do
        echo "  • $(tool_name "$t")"
    done
    echo ""

    # 统计 skills
    local skill_count=$(count_skills)
    info "将要安装: $skill_count 个 Skills"
    echo ""

    # 确认
    if [ -t 0 ]; then
        read -rp "按 Enter 开始安装，或输入 n 取消: " confirm
        if [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
            info "已取消"
            exit 0
        fi
    fi

    # 执行安装
    for tool in "${detected[@]}"; do
        local dest=$(tool_global_dir "$tool")
        echo ""
        info "安装到 $(tool_name "$tool"): $dest"
        mkdir -p "$dest"
        install_all_to "$dest"

        # Kimi 额外配置
        if [ "$tool" = "kimi" ]; then
            configure_kimi
        fi
    done

    echo ""
    ok "安装完成！"
    echo ""
    info "已安装到以下平台:"
    for tool in "${detected[@]}"; do
        echo "  • $(tool_name "$tool") → $(tool_global_dir "$tool")"
    done
    echo ""
}

main "$@"
