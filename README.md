# reset-navicat-premium · 本地实现

无限重置试用 Navicat Premium 所有版本，支持 Windows 和 Mac！亲测 Win10 没啥问题！

推荐使用 `reset_for_windows.bat`！

## 原项目

- 原始项目地址：[malaohu/reset-navicat-premium](https://github.com/malaohu/reset-navicat-premium)

## 本机实现

本项目已在本机（Mac）实现并验证，整理目录：

```
/Volumes/DATA/repos/reset-navicat-premium/
├── README.md
├── reset.sh              # macOS 可执行重置入口（本机适配版）
├── navi-reset.conf       # 路径配置文件
├── reset_for_mac.sh      # macOS 重置脚本（本机已适配）
├── reset.py              # Windows 重置脚本（Python 版）
└── reset_for_windows.bat # Windows 重置脚本（推荐）
```

## 作出的变更与适配

相对于原项目（`malaohu/reset-navicat-premium`），本机实现中做了以下变更：

1. **部署路径适配（macOS）**
   - 原脚本假设 Navicat 安装在 `/Applications/Navicat Premium.app`
   - 本机实际安装在 `/Volumes/DATA/Applications/Navicat Premium.app`
   - 新增 `reset.sh` 自动探测：`/Applications/Navicat Premium.app` → 不存在则改用 `/Volumes/DATA/Applications/Navicat Premium.app`

2. **版本适配（macOS）**
   - 原脚本仅支持 Navicat Premium 15/16/17
   - 本机安装版本为 **Navicat Premium 18.0.5**
   - `reset.sh` 已增加 `18` 版本分支；keychain 清理逻辑覆盖 17/18

3. **Bug 修复**
   - keychain 清理管道 `grep ... || true`：原脚本 `set -e` + grep 无匹配时退出码为 1，导致脚本被中断未输出 `Done`

4. **工程化**
   - 新增可执行入口 `reset.sh`（内部 `source` 同目录 `navi-reset.conf`）
   - 新增 `navi-reset.conf`，集中管理路径配置

## 具体配置指南

`reset.sh` 通过 `navi-reset.conf` 读取路径配置，支持环境变量覆盖：

| 配置项 | 说明 | 默认值 |
|---|---|---|
| `NAVICAT_APP_PATH` | Navicat Premium.app 路径 | `/Applications/Navicat Premium.app` |
| `NAVICAT_SERVICE` | 注册服务名 | `com.navicat.NavicatPremium` |
| `NAVICAT_PREFERENCES` | 试用信息 plist 路径 | `$HOME/Library/Preferences/<service>.plist` |
| `NAVICAT_DATA_DIR` | 试用数据目录 | `$HOME/Library/Application Support/PremiumSoft CyberTech/Navicat CC/Navicat Premium` |
| `NAVICAT_KEYCHAIN` | Keychain 数据库 | `$HOME/Library/Keychains/login.keychain-db` |
| `NAVICAT_KEYCHAIN_SERVICE` | Keychain 服务名 | 同 `NAVICAT_SERVICE` |

环境变量覆盖示例：

```bash
NAVICAT_APP_PATH="/Applications/Navicat Premium.app" \
NAVICAT_SERVICE="com.navicat.NavicatPremium" \
NAVICAT_PREFERENCES="$HOME/Library/Preferences/com.navicat.NavicatPremium.plist" \
NAVICAT_DATA_DIR="$HOME/Library/Application Support/PremiumSoft CyberTech/Navicat CC/Navicat Premium" \
./reset.sh
```

## 如何运行

macOS（本机已适配 Navicat 18）：

```bash
cd /Volumes/DATA/repos/reset-navicat-premium
./reset.sh
```

- 脚本会自动检测 Navicat Premium 版本
- 检测到运行中的 Navicat 时会提示先保存工作，随后自动关闭
- 执行完成后输出 `Done`

Windows：

```bash
# 推荐
reset_for_windows.bat

# Python 版（需 python3）
python reset.py
```

## 更多参考

- https://51.ruyo.net/17611.html
