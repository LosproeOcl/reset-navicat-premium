# reset-navicat-premium
**关键词: Navicat, MacOS, Windows, 破解版, 试用期重置**

Navicat Premium 无限重置试用期（macOS / Windows）：macOS 提供可配置的一键脚本，Windows 提供批处理与 Python 版本，支持自定义安装路径，支持 Navicat Premium 18。


## 项目结构

```
reset-navicat-premium/
├── README.md
├── reset.sh              # macOS 可执行重置入口
├── navi-reset.conf       # 路径配置文件
├── reset_for_mac.sh      # macOS 重置脚本
├── reset.py              # Windows 重置脚本（Python 版）
└── reset_for_windows.bat # Windows 重置脚本（推荐）
```

## 作出的变更与适配

相对于原项目，本版本做了以下调整：

1. **部署路径可配置**
   - 应用路径不再写死：默认 `/Applications/Navicat Premium.app`；如果安装位置不同，修改 `navi-reset.conf` 中的 `NAVICAT_APP_PATH` 即可
   - `reset.sh` 会优先使用配置中的路径，找不到时回退到默认路径

2. **版本自动识别**
   - 启动时读取应用 `Info.plist` 的 `CFBundleShortVersionString`，按主版本号分支处理
   - 已覆盖较新版本（16/17/18）的 plist 与 Keychain 清理逻辑

3. **Bug 修复**
   - Keychain 清理管道在无匹配项时会让 `set -e` 中断脚本；已改为容错处理，保证流程完整输出 `Done`

4. **工程化**
   - 新增入口脚本 `reset.sh`，通过 `source` 加载同目录的 `navi-reset.conf`
   - 路径、服务名、Keychain 等参数集中在 `navi-reset.conf`，便于他人按自己的环境修改

## 具体配置指南

所有可配置项集中在 `navi-reset.conf`，每一项都支持用环境变量覆盖（环境变量优先于文件内的默认值）：

| 配置项 | 说明 | 默认值 |
|---|---|---|
| `NAVICAT_APP_PATH` | Navicat Premium.app 路径 | `/Applications/Navicat Premium.app` |
| `NAVICAT_SERVICE` | 注册服务名 | `com.navicat.NavicatPremium` |
| `NAVICAT_PREFERENCES` | 试用信息 plist 路径 | `$HOME/Library/Preferences/<service>.plist` |
| `NAVICAT_DATA_DIR` | 试用数据目录 | `$HOME/Library/Application Support/PremiumSoft CyberTech/Navicat CC/Navicat Premium` |
| `NAVICAT_KEYCHAIN` | Keychain 数据库 | `$HOME/Library/Keychains/login.keychain-db` |
| `NAVICAT_KEYCHAIN_SERVICE` | Keychain 服务名 | 同 `NAVICAT_SERVICE` |

修改方式有两种，任选其一：

**方式一：直接编辑 `navi-reset.conf`**

```bash
NAVICAT_APP_PATH="/你的安装路径/Navicat Premium.app"
NAVICAT_SERVICE="com.navicat.NavicatPremium"
# 其余保持默认即可
```

**方式二：运行时用环境变量覆盖（不修改文件）**

```bash
NAVICAT_APP_PATH="/你的安装路径/Navicat Premium.app" ./reset.sh
```

> 配置项均采用 `${变量:-默认值}` 写法：没设置时使用默认值，设置了就以设置为准。

## 如何运行

macOS：

```bash
cd reset-navicat-premium
./reset.sh
```

- 脚本自动读取 Navicat Premium 版本
- 若检测到 Navicat 正在运行，会提示先保存工作，随后自动关闭
- 执行完成输出 `Done`

Windows：

```bash
# 推荐
reset_for_windows.bat

# Python 版（需 python3）
python reset.py
```

## 原项目

- 原始项目地址：[malaohu/reset-navicat-premium](https://github.com/malaohu/reset-navicat-premium)
