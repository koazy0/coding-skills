#!/usr/bin/env python3
"""Sync .claude-plugin/marketplace.json with the current skills directory structure."""

import json
import os
import sys

SKILLS_DIR = "skills"
MARKETPLACE_FILE = ".claude-plugin/marketplace.json"


def discover_skills():
    """Discover all skills in the flat structure: skills/<name>/SKILL.md"""
    skills = []
    for skill in sorted(os.listdir(SKILLS_DIR)):
        skill_path = os.path.join(SKILLS_DIR, skill)
        skill_md = os.path.join(skill_path, "SKILL.md")
        if os.path.isdir(skill_path) and os.path.isfile(skill_md):
            skills.append(f"./{SKILLS_DIR}/{skill}")
    return skills


def generate_marketplace(skills):
    return {
        "metadata": {
            "name": "coding-skills",
            "description": "Flat coding skills for AI agents"
        },
        "plugins": [
            {
                "name": "coding-skills",
                "source": "coding-skills",
                "skills": skills
            }
        ]
    }


def main():
    skills = discover_skills()
    data = generate_marketplace(skills)

    os.makedirs(os.path.dirname(MARKETPLACE_FILE), exist_ok=True)

    with open(MARKETPLACE_FILE, "w") as f:
        json.dump(data, f, indent=2)

    print(f"Synced {MARKETPLACE_FILE} with {len(skills)} skills")
    return 0


if __name__ == "__main__":
    sys.exit(main())
