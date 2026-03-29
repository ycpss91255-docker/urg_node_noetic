# 測試文件

**39 個測試**。

## test/smoke/ros_env.bats

### ROS environment (3)

| 測試項目 | 說明 |
|----------|------|
| `ROS_DISTRO is set` | ROS_DISTRO environment variable is set |
| `ROS 1 setup.bash exists` | `/opt/ros/${ROS_DISTRO}/setup.bash` exists |
| `ROS 1 setup.bash can be sourced` | ROS 1 setup script sources without error |

### urg_node packages (2)

| 測試項目 | 說明 |
|----------|------|
| `urg_node is installed` | `ros-${ROS_DISTRO}-urg-node` package installed |
| `laser_proc is installed` | `ros-${ROS_DISTRO}-laser-proc` package installed |

### Base tools (2)

| 測試項目 | 說明 |
|----------|------|
| `git is available` | git command works |
| `sudo passwordless works` | sudo runs without password |

### System (4)

| 測試項目 | 說明 |
|----------|------|
| `User is not root` | Container user is not root |
| `Timezone is Asia/Taipei` | Timezone configured correctly |
| `LANG is en_US.UTF-8` | LANG locale set |
| `entrypoint.sh exists and executable` | `/entrypoint.sh` is executable |

### Workspace (1)

| 測試項目 | 說明 |
|----------|------|
| `Work directory exists` | `${HOME}/work` directory exists |

## template/test/smoke/script_help.bats

### build.sh (3)

| 測試項目 | 說明 |
|----------|------|
| `build.sh -h exits 0` | Help exits successfully |
| `build.sh --help exits 0` | Help exits successfully |
| `build.sh -h prints usage` | Help output contains "Usage:" |

### run.sh (3)

| 測試項目 | 說明 |
|----------|------|
| `run.sh -h exits 0` | Help exits successfully |
| `run.sh --help exits 0` | Help exits successfully |
| `run.sh -h prints usage` | Help output contains "Usage:" |

### exec.sh (3)

| 測試項目 | 說明 |
|----------|------|
| `exec.sh -h exits 0` | Help exits successfully |
| `exec.sh --help exits 0` | Help exits successfully |
| `exec.sh -h prints usage` | Help output contains "Usage:" |

### stop.sh (3)

| 測試項目 | 說明 |
|----------|------|
| `stop.sh -h exits 0` | Help exits successfully |
| `stop.sh --help exits 0` | Help exits successfully |
| `stop.sh -h prints usage` | Help output contains "Usage:" |

### LANG auto-detect (4)

| 測試項目 | 說明 |
|----------|------|
| `build.sh detects zh from LANG=zh_TW.UTF-8` | Detects Traditional Chinese |
| `build.sh detects ja from LANG=ja_JP.UTF-8` | Detects Japanese |
| `build.sh defaults to en for LANG=en_US.UTF-8` | Defaults to English |
| `build.sh SETUP_LANG overrides LANG` | SETUP_LANG takes priority |

## template/test/smoke/display_env.bats

### Wayland env vars (3)

| 測試項目 | 說明 |
|----------|------|
| `compose.yaml contains WAYLAND_DISPLAY env` | WAYLAND_DISPLAY in compose.yaml |
| `compose.yaml contains XDG_RUNTIME_DIR env` | XDG_RUNTIME_DIR in compose.yaml |
| `compose.yaml contains XAUTHORITY env` | XAUTHORITY in compose.yaml |

### Display mounts (4)

| 測試項目 | 說明 |
|----------|------|
| `compose.yaml mounts XDG_RUNTIME_DIR as rw` | XDG_RUNTIME_DIR mounted read-write |
| `compose.yaml mounts XAUTHORITY volume` | XAUTHORITY volume mounted |
| `compose.yaml has no consecutive duplicate keys` | No YAML duplicate key errors |
| `compose.yaml mounts X11-unix volume` | X11 socket mounted |

### xhost branching (4)

| 測試項目 | 說明 |
|----------|------|
| `run.sh contains XDG_SESSION_TYPE check` | Session type detection present |
| `run.sh calls xhost +SI:localuser on wayland` | Wayland xhost command correct |
| `run.sh calls xhost +local: on X11` | X11 xhost command correct |
| `run.sh defaults to X11 xhost when XDG_SESSION_TYPE unset` | Falls back to X11 |
