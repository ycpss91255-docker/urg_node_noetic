**[English](../README.md)** | **[繁體中文](README.zh-TW.md)** | **[简体中文](README.zh-CN.md)** | **[日本語](README.ja.md)**

# Hokuyo URG LiDAR Docker コンテナ（ROS 1 Noetic）

> **TL;DR** — コンテナ化された Hokuyo URG LiDAR ROS 1 Noetic ドライバ。apt で `ros-noetic-urg-node` と `ros-noetic-laser-proc` をインストールし、デフォルトで `urg_lidar.launch` を起動します。
>
> ```bash
> ./build.sh && ./run.sh
> ```

## 目次

- [機能](#機能)
- [クイックスタート](#クイックスタート)
- [使い方](#使い方)
- [設定](#設定)
- [アーキテクチャ](#アーキテクチャ)
- [Smoke Tests](#smoke-tests)
- [ディレクトリ構成](#ディレクトリ構成)

---

## 機能

- **Apt ベースのインストール**：ROS apt リポジトリから `ros-noetic-urg-node` と `ros-noetic-laser-proc` をインストール
- **Smoke Test**：Bats テストがビルド時に自動実行され、環境を検証
- **Docker Compose**：単一の `compose.yaml` で全ターゲットを管理
- **Privileged モード**：センサーアクセス用に `/dev` をマウントして事前設定済み
- **マルチアーキテクチャ**：x86_64 と ARM64（RPi、Jetson CPU モード）をサポート

## クイックスタート

```bash
# 1. ビルド
./build.sh

# 2. 実行（デフォルト：roslaunch urg_node urg_lidar.launch）
./run.sh

# または docker compose を直接使用
docker compose up runtime
docker compose down
```

## 使い方

### ランタイム

```bash
./build.sh                       # ビルド（デフォルト：runtime）
./build.sh --no-env test         # .env を更新せずにビルド
./run.sh                         # 起動（デフォルト：runtime）
./exec.sh                        # 実行中のコンテナに入る
./stop.sh                        # コンテナを停止・削除

docker compose build runtime     # 同等のコマンド
docker compose up runtime        # 起動
docker compose exec runtime bash # 実行中のコンテナに入る
```

### テスト（test）

Smoke tests はビルド時に自動実行されます。テスト失敗時はビルドも失敗します。

```bash
./build.sh test
# または
docker compose --profile test build test
```

## 設定

### .env パラメータ

| 変数 | 説明 | 例 |
|------|------|-----|
| `DOCKER_HUB_USER` | Docker Hub ユーザー名 | `myuser` |
| `IMAGE_NAME` | イメージ名 | `urg_node_noetic` |

## アーキテクチャ

### Docker ビルドステージ図

```mermaid
graph TD
    EXT1["bats/bats:latest"]:::external
    EXT2["alpine:latest"]:::external
    EXT3["ros:noetic-ros-base-focal"]:::external

    EXT1 --> bats-src["bats-src"]:::tool
    EXT2 --> bats-ext["bats-extensions"]:::tool

    EXT3 --> runtime["runtime\nurg_node + laser_proc"]:::stage

    bats-src --> test["test  ⚡ ephemeral\nsmoke tests, discarded after build"]:::ephemeral
    bats-ext --> test
    runtime --> test

    classDef external fill:#555,color:#fff,stroke:#999
    classDef tool fill:#8B6914,color:#fff,stroke:#c8960c
    classDef stage fill:#1a5276,color:#fff,stroke:#2980b9
    classDef ephemeral fill:#6e2c00,color:#fff,stroke:#e67e22,stroke-dasharray:5 5
```

### ステージ説明

| ステージ | FROM | 用途 |
|----------|------|------|
| `bats-src` | `bats/bats:latest` | Bats バイナリソース、出荷しない |
| `bats-extensions` | `alpine:latest` | bats-support、bats-assert、出荷しない |
| `lint-tools` | `alpine:latest` | ShellCheck + Hadolint、出荷しない |
| `runtime` | `ros:noetic-ros-base-focal` | urg_node + laser_proc パッケージ |
| `test` | `runtime` | Lint + smoke tests、ビルド後に破棄 |

## Smoke Tests

`test/smoke_test/` に配置 — `docker build --target test` 時に自動実行 — 合計 **22 テスト**。

<details>
<summary>クリックしてテスト詳細を展開</summary>

#### ROS 環境（3）

| テスト項目 | 説明 |
|------------|------|
| `ROS_DISTRO` | 設定済み |
| `setup.bash` | ファイルが存在する |
| `setup.bash` | source 可能 |

#### urg_node パッケージ（2）

| テスト項目 | 説明 |
|------------|------|
| `urg_node` | `rospack find` で確認可能 |
| `laser_proc` | `rospack find` で確認可能 |

#### システム（1）

| テスト項目 | 説明 |
|------------|------|
| `entrypoint.sh` | 存在し実行可能 |

#### Script help（16）

| テスト項目 | 説明 |
|------------|------|
| `build.sh -h` | 終了コード 0 |
| `build.sh --help` | 終了コード 0 |
| `build.sh -h` | usage を表示 |
| `run.sh -h` | 終了コード 0 |
| `run.sh --help` | 終了コード 0 |
| `run.sh -h` | usage を表示 |
| `exec.sh -h` | 終了コード 0 |
| `exec.sh --help` | 終了コード 0 |
| `exec.sh -h` | usage を表示 |
| `stop.sh -h` | 終了コード 0 |
| `stop.sh --help` | 終了コード 0 |
| `stop.sh -h` | usage を表示 |
| `build.sh -h` | `LANG=zh_TW.UTF-8` から zh を検出 |
| `build.sh -h` | `LANG=ja_JP.UTF-8` から ja を検出 |
| `build.sh -h` | `LANG=en_US.UTF-8` はデフォルトで en |
| `build.sh -h` | `SETUP_LANG` が LANG を上書き |

</details>

## ディレクトリ構成

```text
urg_node_noetic/
├── compose.yaml                 # Docker Compose 定義
├── Dockerfile                   # マルチステージビルド
├── build.sh                     # ビルドスクリプト
├── run.sh                       # 実行スクリプト
├── exec.sh                      # 実行中のコンテナに入る
├── stop.sh                      # コンテナを停止・削除
├── .env.example                 # 環境変数テンプレート
├── .hadolint.yaml               # Hadolint 無視ルール
├── script/
│   └── entrypoint.sh            # コンテナエントリポイント
├── doc/
│   ├── README.zh-TW.md          # 繁体字中国語
│   ├── README.zh-CN.md          # 簡体字中国語
│   └── README.ja.md             # 日本語
├── .github/workflows/           # CI/CD
│   ├── main.yaml                # メインパイプライン
│   ├── build-worker.yaml        # Docker ビルド + smoke test
│   └── release-worker.yaml      # GitHub Release
└── test/
    └── smoke_test/              # Bats 環境テスト
        ├── ros_env.bats
        ├── script_help.bats
        └── test_helper.bash
```
