**[English](../README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# Hokuyo URG LiDAR Docker 容器（ROS 1 Noetic）

> **TL;DR** — 容器化的 Hokuyo URG LiDAR ROS 1 Noetic 驱动程序。通过 apt 安装 `ros-noetic-urg-node` 和 `ros-noetic-laser-proc`，默认启动 `urg_lidar.launch`。
>
> ```bash
> ./build.sh && ./run.sh
> ```

## 目录

- [功能特性](#功能特性)
- [快速开始](#快速开始)
- [使用方式](#使用方式)
- [配置](#配置)
- [架构](#架构)
- [Smoke Tests](#smoke-tests)
- [目录结构](#目录结构)

---

## 功能特性

- **Apt 安装**：从 ROS apt 软件源安装 `ros-noetic-urg-node` 和 `ros-noetic-laser-proc`
- **Smoke Test**：Bats 测试在构建时自动执行，验证环境正确性
- **Docker Compose**：单一 `compose.yaml` 管理所有目标
- **Privileged 模式**：预配置挂载 `/dev` 以访问传感器
- **多架构支持**：支持 x86_64 和 ARM64（RPi、Jetson CPU 模式）

## 快速开始

```bash
# 1. 构建
./build.sh

# 2. 运行（默认：roslaunch urg_node urg_lidar.launch）
./run.sh

# 或直接使用 docker compose
docker compose up runtime
docker compose down
```

## 使用方式

### 运行环境

```bash
./build.sh                       # 构建（默认：runtime）
./build.sh --no-env test         # 构建但不更新 .env
./run.sh                         # 启动（默认：runtime）
./exec.sh                        # 进入运行中的容器
./stop.sh                        # 停止并移除容器

docker compose build runtime     # 等效命令
docker compose up runtime        # 启动
docker compose exec runtime bash # 进入运行中的容器
```

### 测试（test）

Smoke tests 在构建时自动执行；测试失败则构建失败。

```bash
./build.sh test
# 或
docker compose --profile test build test
```

## 配置

### .env 参数

| 变量 | 说明 | 示例 |
|------|------|------|
| `DOCKER_HUB_USER` | Docker Hub 用户名 | `myuser` |
| `IMAGE_NAME` | 镜像名称 | `urg_node_noetic` |

## 架构

### Docker 构建阶段图

```mermaid
graph TD
    EXT1["bats/bats:latest"]:::external
    EXT2["alpine:latest"]:::external
    EXT3["ros:noetic-ros-base-focal"]:::external

    EXT1 --> bats-src["bats-src"]:::tool
    EXT2 --> bats-ext["bats-extensions"]:::tool

    EXT3 --> runtime["runtime\nurg_node + laser_proc"]:::stage

    bats-src --> test["test临时性\nsmoke test，构建后丢弃"]:::ephemeral
    bats-ext --> test
    runtime --> test

    classDef external fill:#555,color:#fff,stroke:#999
    classDef tool fill:#8B6914,color:#fff,stroke:#c8960c
    classDef stage fill:#1a5276,color:#fff,stroke:#2980b9
    classDef ephemeral fill:#6e2c00,color:#fff,stroke:#e67e22,stroke-dasharray:5 5
```

### 阶段说明

| 阶段 | FROM | 用途 |
|------|------|------|
| `bats-src` | `bats/bats:latest` | Bats 可执行文件来源，不出货 |
| `bats-extensions` | `alpine:latest` | bats-support、bats-assert，不出货 |
| `lint-tools` | `alpine:latest` | ShellCheck + Hadolint，不出货 |
| `runtime` | `ros:noetic-ros-base-focal` | urg_node + laser_proc 软件包 |
| `test` | `runtime` | Lint + smoke tests，构建后丢弃 |

## Smoke Tests

位于 `test/smoke/` — 在 `docker build --target test` 时自动执行 — 共 **22 项测试**。

<details>
<summary>点击展开测试详情</summary>

#### ROS 环境（3）

| 测试项目 | 说明 |
|----------|------|
| `ROS_DISTRO` | 已设置 |
| `setup.bash` | 文件存在 |
| `setup.bash` | 可被 source |

#### urg_node 软件包（2）

| 测试项目 | 说明 |
|----------|------|
| `urg_node` | 可通过 `rospack find` 查询到 |
| `laser_proc` | 可通过 `rospack find` 查询到 |

#### 系统（1）

| 测试项目 | 说明 |
|----------|------|
| `entrypoint.sh` | 存在且可执行 |

#### Script help（16）

| 测试项目 | 说明 |
|----------|------|
| `build.sh -h` | 退出码 0 |
| `build.sh --help` | 退出码 0 |
| `build.sh -h` | 显示 usage |
| `run.sh -h` | 退出码 0 |
| `run.sh --help` | 退出码 0 |
| `run.sh -h` | 显示 usage |
| `exec.sh -h` | 退出码 0 |
| `exec.sh --help` | 退出码 0 |
| `exec.sh -h` | 显示 usage |
| `stop.sh -h` | 退出码 0 |
| `stop.sh --help` | 退出码 0 |
| `stop.sh -h` | 显示 usage |
| `build.sh -h` | 从 `LANG=zh_TW.UTF-8` 检测为 zh |
| `build.sh -h` | 从 `LANG=ja_JP.UTF-8` 检测为 ja |
| `build.sh -h` | `LANG=en_US.UTF-8` 默认为 en |
| `build.sh -h` | `SETUP_LANG` 覆盖 LANG |

</details>

## 目录结构

```text
urg_node_noetic/
├── compose.yaml                 # Docker Compose 定义
├── Dockerfile                   # 多阶段构建
├── build.sh                     # 构建脚本
├── run.sh                       # 运行脚本
├── exec.sh                      # 进入运行中的容器
├── stop.sh                      # 停止并移除容器
├── .env.example                 # 环境变量模板
├── .hadolint.yaml               # Hadolint 忽略规则
├── script/
│   └── entrypoint.sh            # 容器入口点
├── doc/
│   ├── README.zh-TW.md          # 繁体中文
│   ├── README.zh-CN.md          # 简体中文
│   └── README.ja.md             # 日文
├── .github/workflows/           # CI/CD
│   ├── main.yaml                # 主要流程
│   ├── build-worker.yaml        # Docker 构建 + smoke test
│   └── release-worker.yaml      # GitHub Release
└── test/
    └── smoke/              # Bats 环境测试
        ├── ros_env.bats
        ├── script_help.bats
        └── test_helper.bash
```
