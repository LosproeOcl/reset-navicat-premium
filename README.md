# reset-navicat-premium
无限重置试用 navicat premium所有版本, 支持Windows 和 MAC !   亲测Win10没啥问题！

推荐使用 reset_for_xxxx.bat !



reset.py 需要 python3环境才行！仅供学习使用！

更多参考：https://51.ruyo.net/17611.html

## macOS 重置脚本（可执行 + 可配置）

本机适配版：`reset.sh`（可执行，已支持 Navicat Premium 18）。

```bash
./reset.sh
```

脚本内部通过 `navi-reset.conf` 读取路径配置；部署到 GitHub 后，其他人改自己的机器路径即可：

```bash
# 常用环境变量覆盖示例
NAVICAT_APP_PATH="/Applications/Navicat Premium.app" \
NAVICAT_SERVICE="com.navicat.NavicatPremium" \
NAVICAT_PREFERENCES="$HOME/Library/Preferences/com.navicat.NavicatPremium.plist" \
NAVICAT_DATA_DIR="$HOME/Library/Application Support/PremiumSoft CyberTech/Navicat CC/Navicat Premium" \
./reset.sh
```

| 配置项 | 说明 | 默认值 |
|---|---|---|
| `NAVICAT_APP_PATH` | Navicat Premium.app 路径 | `/Applications/Navicat Premium.app` |
| `NAVICAT_SERVICE` | 注册服务名 | `com.navicat.NavicatPremium` |
| `NAVICAT_PREFERENCES` | 试用信息 plist 路径 | `$HOME/Library/Preferences/<service>.plist` |
| `NAVICAT_DATA_DIR` | 试用数据目录 | `$HOME/Library/Application Support/PremiumSoft CyberTech/Navicat CC/Navicat Premium` |
| `NAVICAT_KEYCHAIN` | Keychain 数据库 | `$HOME/Library/Keychains/login.keychain-db` |
| `NAVICAT_KEYCHAIN_SERVICE` | Keychain 服务名 | 同 `NAVICAT_SERVICE` |
