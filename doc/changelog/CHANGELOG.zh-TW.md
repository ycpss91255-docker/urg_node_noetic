**[English](CHANGELOG.md)** | **[繁體中文](CHANGELOG.zh-TW.md)** | **[简体中文](CHANGELOG.zh-CN.md)** | **[日本語](CHANGELOG.ja.md)**

# 變更記錄

格式基於 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
版本號遵循 [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [未發布]

### 修復
- revert display mount to XDG_RUNTIME_DIR:rw
- use tmpfs for XDG_RUNTIME_DIR + Wayland socket mount

## [v2.0.0] - 2026-03-28

### 新增
- migrate from docker_setup_helper to docker_template
- add Wayland display support for X11/Wayland dual compatibility

### 變更
- remove docker_setup_helper subtree and local CI workflows
- add docker_setup_helper subtree
- Squashed 'docker_setup_helper/' content from commit 0141a19
- upgrade to full env-level architecture

### 修復
- add missing backslash in Dockerfile RUN continuation

## [v1.0.0] - 2026-03-25

### 新增
- initial urg_node_noetic repo

