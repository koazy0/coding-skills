#!/usr/bin/env bash
set -euo pipefail

# Skills multi-platform installer
# Project structure: flat  (skills/<name>/SKILL.md)
# Usage: bash install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { printf "${CYAN}[*]${RESET} %s\n" "$*"; }
ok()   { printf "${GREEN}[+]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[!]${RESET} %s\n" "$*"; }
fail() { printf "${RED}[x]${RESET} %s\n" "$*"; exit 1; }

# === Platform Registry ===
# key|display_name|install_dir
# To add a platform: append one line + add install_to_<key>() below.

platform_registry() {
    cat <<'EOF'
claude|Claude Code|$HOME/.claude/skills
kimi|Kimi Code CLI|$HOME/.kimi/skills
codex|OpenAI Codex|$HOME/.codex/skills
codebuddy|CodeBuddy|$HOME/.codebuddy/skills
hermes|Hermes Agent|$HOME/.hermes/skills
openclaw|OpenClaw|$HOME/.openclaw/skills
EOF
}

platform_name() {
    platform_registry | awk -F'|' -v k="$1" '$1==k {print $2}'
}

platform_dir() {
    local dir
    dir=$(platform_registry | awk -F'|' -v k="$1" '$1==k {print $3}')
    eval echo "$dir"
}

detect_tools() {
    platform_registry | while IFS='|' read -r key _ _; do
        [ -d "$HOME/.$key" ] && echo "$key"
    done
}

# === Install Strategies ===

cp_to_safe() {
    local src="$1" dst="$2"
    if [ -d "$dst" ] && [ -f "$dst/SKILL.md" ]; then
        warn "  -> skipped (already exists): $(basename "$dst")"
        return 1
    fi
    mkdir -p "$dst"
    cp -r "$src"/* "$dst/"
    return 0
}

# Flat structure: dest/<name>/SKILL.md
install_flat_to() {
    local dest="$1"
    for skill_dir in "$SKILLS_DIR"/*/; do
        [ -f "$skill_dir/SKILL.md" ] || continue
        local name=$(basename "$skill_dir")
        if cp_to_safe "$skill_dir" "$dest/$name"; then
            ok "  -> $name"
        fi
    done
}

count_skills() {
    find "$SKILLS_DIR" -name "SKILL.md" -type f | wc -l
}

# === Per-Platform Installers ===
# Each platform defines its own: optional config on top of flat install.

install_to_claude()    { install_flat_to "$1"; }
install_to_kimi()      { install_flat_to "$1"; configure_kimi; }
install_to_codex()     { install_flat_to "$1"; }
install_to_codebuddy() { install_flat_to "$1"; }
install_to_hermes()    { install_flat_to "$1"; configure_hermes; }
install_to_openclaw()  { install_flat_to "$1"; configure_openclaw; }

# === Tool Configuration ===

configure_kimi() {
    local config_file="$HOME/.kimi/config.toml"
    if [ ! -f "$config_file" ]; then
        warn "  Kimi config not found: $config_file"
        return
    fi

    info "  Configuring Kimi Code CLI..."

    if grep -q "^merge_all_available_skills" "$config_file"; then
        sed -i 's/^merge_all_available_skills[[:space:]]*=.*/merge_all_available_skills = true/' "$config_file"
    else
        sed -i '1i\merge_all_available_skills = true' "$config_file"
    fi

    local dirs='["~/.kimi/skills", "~/.claude/skills"]'
    if grep -q "^extra_skill_dirs" "$config_file"; then
        sed -i "s#^extra_skill_dirs[[:space:]]*=.*#extra_skill_dirs = $dirs#" "$config_file"
    else
        sed -i "/^merge_all_available_skills/a\\extra_skill_dirs = $dirs" "$config_file"
    fi

    ok "  Kimi config updated"
}

configure_hermes() {
    local config_file="$HOME/.hermes/config.yaml"
    if [ ! -f "$config_file" ]; then
        warn "  Hermes config not found: $config_file"
        return
    fi

    info "  Configuring Hermes Agent..."

    if grep -q "external_dirs" "$config_file"; then
        if ! grep -q "~/.claude/skills" "$config_file"; then
            warn "  Found existing external_dirs. Please add the following manually:"
            echo "    - ~/.claude/skills"
            echo "    - ~/.kimi/skills"
        else
            ok "  External skill dirs already configured"
        fi
    else
        {
            echo ""
            echo "skills:"
            echo "  external_dirs:"
            echo "    - ~/.claude/skills"
            echo "    - ~/.kimi/skills"
        } >> "$config_file"
        ok "  Hermes config updated"
    fi
}

configure_openclaw() {
    local config_file="$HOME/.openclaw/openclaw.json"
    if [ ! -f "$config_file" ]; then
        warn "  OpenClaw config not found: $config_file"
        return
    fi

    info "  Configuring OpenClaw..."

    if grep -q "extraDirs" "$config_file"; then
        if ! grep -q "~/.claude/skills" "$config_file"; then
            warn "  Found existing extraDirs. Please add the following manually:"
            echo "    \"$HOME/.claude/skills\","
            echo "    \"$HOME/.kimi/skills\""
        else
            ok "  Extra skill dirs already configured"
        fi
    else
        if grep -q '"skills"' "$config_file" || grep -q "'skills'" "$config_file" || grep -q '"load"' "$config_file"; then
            warn "  Complex config detected. Please add extraDirs manually under skills.load:"
            echo "    \"$HOME/.claude/skills\","
            echo "    \"$HOME/.kimi/skills\""
        else
            {
                echo ""
                echo "skills: {"
                echo "  load: {"
                echo "    extraDirs: [\"$HOME/.claude/skills\", \"$HOME/.kimi/skills\"]"
                echo "  }"
                echo "}"
            } >> "$config_file"
            ok "  OpenClaw config updated"
        fi
    fi
}

# === Main Flow ===

main() {
    echo ""
    echo "====================== Skills Installer ======================"
    echo ""

    local detected=()
    while IFS= read -r t; do
        detected+=("$t")
    done < <(detect_tools)

    if [ ${#detected[@]} -eq 0 ]; then
        warn "No AI coding tools detected"
        echo ""
        echo "Supported targets:"
        platform_registry | while IFS='|' read -r key name dir; do
            eval local d="$dir"
            printf "  %-20s (%s)\n" "$d" "$name"
        done
        echo ""
        fail "Please install at least one supported AI tool before running this script"
    fi

    info "Detected tools:"
    for t in "${detected[@]}"; do
        echo "  - $(platform_name "$t")"
    done
    echo ""

    local skill_count=$(count_skills)
    info "Skills to install: $skill_count"
    echo ""

    if [ -t 0 ]; then
        read -rp "Press Enter to install, or type n to cancel: " confirm
        if [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
            info "Cancelled"
            exit 0
        fi
    fi

    for tool in "${detected[@]}"; do
        local dest=$(platform_dir "$tool")
        local installer="install_to_$tool"
        echo ""
        info "Installing to $(platform_name "$tool"): $dest"
        mkdir -p "$dest"
        "$installer" "$dest"
    done

    echo ""
    ok "Installation complete!"
    echo ""
    info "Installed to:"
    for tool in "${detected[@]}"; do
        echo "  - $(platform_name "$tool") -> $(platform_dir "$tool")"
    done
    echo ""
}

main "$@"
