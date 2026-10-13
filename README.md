<div align="center">

<img src="docs/hero.svg" alt="Net Speed Adapter — choose the adapter, see the traffic" width="100%">

# Net Speed Adapter

**让任务栏显示你真正想看的网速。**

为 Windows 任务栏添加实时上传 / 下载速度，可指定网卡，保留简洁文字与迷你曲线四种布局。

[![Version](https://img.shields.io/badge/version-1.6.2-58cdb6?style=flat-square)](https://github.com/CyberYuno/windhawk-net-speed-adapter/releases/latest)
[![Windhawk](https://img.shields.io/badge/Windhawk-mod-f2bc78?style=flat-square)](https://windhawk.net/)
[![Platform](https://img.shields.io/badge/Windows_11-x64-84b9e8?style=flat-square)](#验证环境)
[![License](https://img.shields.io/badge/license-MIT-a9b0bb?style=flat-square)](LICENSE)

[安装](#安装) · [配置](#配置) · [更新记录](CHANGELOG.md) · [English](README.en.md)

</div>

## 两个小改进，解决两个具体问题

| | 上游 1.6 | 本改版 1.6.2 |
|---|---|---|
| **选哪块网卡** | 根据访问 `8.8.8.8` 的路由自动选择 | 可按名称指定 `WLAN`、`Wi-Fi` 或 `Ethernet`；留空沿用自动选择 |
| **高速时的单位** | Minimal 的固定窄列可能让三位数速度后的单位换行、裁切 | 加宽文字区域并禁止换行，完整显示 `100.0 MB/s` 等读数 |

当 VPN 或代理的虚拟网卡接管某些目标地址的路由时，自动选网卡可能只显示虚拟网卡的少量流量。指定实际联网的物理网卡后，显示的是该网卡的全部收发流量。

保留上游功能：每秒刷新、四种布局、水平位置调节、字号与透明度设置，以及全屏时隐藏。

## 安装

需要安装 [Windhawk](https://windhawk.net/)。本仓库提供可在 Windhawk 中编译安装的模组源码。

1. 打开 [源码文件](net-speed-taskbar-adapter.wh.cpp)，点击 **Raw**，复制完整内容。
2. 打开 Windhawk，点击 **新建 Mod / Create a new mod**。
3. 用本仓库源码替换编辑器中 `mod.wh.cpp` 的全部内容。
4. 点击左侧 **编译 / Compile**。左侧栏可见时，也可按 `Ctrl+B`。
5. 编译成功后退出编辑模式，确认 **Taskbar Network Speed Indicator (Adapter Selection)** 已启用。
6. 打开模组的 **设置 / Settings**，填写实际联网的网卡名称并保存。

如果已经安装上游 **Taskbar Network Speed Indicator**，将上游模组关闭，只启用这个改版，以免重复显示。

安装方式参考 Windhawk 官方的 [编辑模式指南](https://github.com/ramensoftware/windhawk/wiki/Editing-mode-guidelines)。本改版通过本地源码安装，尚未收录到 Windhawk 在线模组目录。

## 配置

### 先选对网卡

**Network adapter name** 默认是 `WLAN`。请使用 Windows 中显示的网卡名称；英文系统可能叫 `Wi-Fi` 或 `Ethernet`，中文系统也可能叫 `以太网`。

在 PowerShell 中查看名称：

```powershell
Get-NetAdapter | Select-Object Name, InterfaceDescription, Status
```

通常选择状态为 `Up` 的实际 Wi-Fi 或有线网卡。此选项匹配 **Name**，不是 **InterfaceDescription**。如果填写的网卡不存在或未连接，读数为零；留空则恢复上游的路由自动选择。

### 简洁任务栏示例

在模组设置中切换到文本模式，填写：

```yaml
adapterName: WLAN
theme: Minimal
horizontalPosition: 80
verticalNudge: 0
updateIntervalMs: 1000
fontSize: 16
opacity: 235
```

| 设置 | 作用 |
|---|---|
| `adapterName` | 要监控的 Windows 网卡名称；留空自动选择 |
| `theme` | `Minimal`、`Top-Down`、`Side-by-Side`、`Chart` |
| `horizontalPosition` | `0` 靠左，`100` 靠右；选任务栏空白位置 |
| `verticalNudge` | 垂直偏移，单位为像素 |
| `updateIntervalMs` | 刷新间隔，默认 `1000` 毫秒 |
| `fontSize` | 字号，默认 `13` |
| `opacity` | 透明度，范围 `0`–`255` |

组件覆盖在任务栏表面，不会自动为应用按钮预留空间；用水平位置避开应用图标、托盘和时钟。单位按流量自动切换为 `B/s`、`KB/s`、`MB/s`，其中 `MB/s` 表示字节每秒，和测速网站常用的 `Mbps` 相差约 8 倍。

## 验证环境

- **Windows 11 `26300.9550` x64**，顶部任务栏。
- **Windhawk `1.7.3`**，编译和运行通过。
- 指定物理 Wi-Fi 网卡后，实际测速读数正常；超过 `100 MB/s` 时单位显示正常。
- 字号 `16` 下，对 `100.0`、`125.0`、`999.9 MB/s` 做了 100%、125%、150%、200% 缩放的文字宽度检查。

上方封面为界面示意，非实测截图。

## 开发

模组是一个 C++ 源码文件。可以直接用 Windhawk 编辑器编译，或使用仓库中的构建脚本：

```powershell
pwsh -NoProfile -File .\scripts\build.ps1 -WindhawkPath 'C:\Program Files\Windhawk'
```

将参数改为 Windhawk 的实际安装目录。脚本使用其自带编译器和引擎导入库，输出到 `build/`，不修改已安装模组。

## 来源与许可

本项目基于 **[Taskbar Network Speed Indicator 1.6](https://github.com/ramensoftware/windhawk-mods/blob/main/mods/net-speed-taskbar.wh.cpp)**，原作者为 **[Narayan](https://github.com/NarayanChetri)**。上游源码位于 [Windhawk 官方模组合集](https://github.com/ramensoftware/windhawk-mods)。

**[CyberYuno](https://github.com/CyberYuno)** 维护此独立改版，新增网卡名称选择并修复 Minimal 布局裁切。原作者署名保留，代码使用 [MIT License](LICENSE)。
