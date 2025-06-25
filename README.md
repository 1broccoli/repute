# Repute

[![GitHub release](https://img.shields.io/github/v/release/1broccoli/repute?style=flat-square)](https://github.com/1broccoli/repute/releases)
[![GitHub license](https://img.shields.io/github/license/1broccoli/repute?style=flat-square)](https://github.com/1broccoli/repute/blob/main/LICENSE)
[![WoW Classic](https://img.shields.io/badge/WoW-Classic%20Era-orange?style=flat-square)](https://worldofwarcraft.com/en-us/wowclassic)
[![Lua](https://img.shields.io/badge/Language-Lua-blue?style=flat-square)](https://www.lua.org/)

**A comprehensive World of Warcraft Classic addon that enhances reputation and honor tracking with custom chat messages, class-colored player names, and intelligent battleground detection.**

## ✨ Features

### 🎖️ **Enhanced Honor System**
- **Custom Honor Messages**: Replace Blizzard's default honor messages with clean, customizable formats
- **Class-Colored Player Names**: Automatically color enemy player names by their class using multiple detection sources
- **Battleground Integration**: Special (BG) tags for battleground objective honor with smart detection
- **PvP Kill Tracking**: Detailed honor messages showing player rank and estimated honor points

### 📊 **Advanced Reputation Tracking**
- **Real-time Reputation Updates**: Track all faction reputation changes in chat
- **Multi-Character Support**: View reputation progress across all your characters
- **Item Integration**: Tooltip enhancements showing reputation rewards and requirements
- **Quest Status Tracking**: Monitor completion status for reputation-related quests

### ⚙️ **Smart Detection & Performance**
- **Multiple Class Detection Sources**: Integrates with Spy addon, unit frames, guild/friends lists
- **Intelligent Caching**: Performance-optimized with automatic cache cleanup
- **Battleground Auto-Detection**: Smart detection using instance type and keyword analysis
- **Ace3 Framework**: Built on the robust Ace3 library for stability and compatibility

## 📦 Installation

### Method 1: Manual Installation
1. Download the latest release from the [Releases page](https://github.com/1broccoli/repute/releases)
2. Extract the `Repute` folder to your WoW Classic addons directory:
   ```
   World of Warcraft\_classic_era_\Interface\AddOns\
   ```
3. Restart World of Warcraft or reload your UI (`/reload`)

### Method 2: Addon Manager
- **CurseForge**: Search for "Repute" in the CurseForge client
- **WowUp**: Available in the WowUp addon manager

## 🚀 Usage

### Quick Start
1. Install the addon and log into your character
2. The addon automatically starts tracking reputation and honor
3. Access settings via `/repute` command or the minimap button
4. Customize your experience through the settings panel

### Chat Commands
- `/repute` or `/rep` - Opens the settings panel
- Settings are automatically saved per character

### Honor Message Examples
```
+123 Honor | Enemymage (Grand Marshal)     # PvP kill with class color
+15 Honor (BG)                             # Battleground objective
+50 Honor                                  # General honor award
```

## ⚙️ Configuration

### Settings Panel Options
- **Show Custom Honor Messages**: Toggle custom honor message display
- **Show Class Colors**: Enable/disable class-colored player names
- **Show (BG) Tag**: Display battleground tags for BG objective honor
- **Test Messages**: Preview different message formats

### Advanced Features
- **Smart Cache**: Automatically manages class detection cache for optimal performance
- **Multi-Source Detection**: Uses Spy addon, unit frames, and social lists for class detection
- **Battleground Auto-Detection**: Intelligently identifies BG objectives vs regular honor

## 🔧 Dependencies

### Required
- **World of Warcraft Classic Era** (Season of Discovery, Hardcore, or Era realms)
- **Ace3 Libraries** (included with the addon)

### Optional (Enhanced Features)
- **Spy Addon**: Provides additional class detection for enemy players
- **LibDataBroker**: Enhanced minimap button functionality
- **LibDBIcon**: Minimap icon positioning and management

## 🤝 Compatibility

- ✅ **WoW Classic Era** (all versions)
- ✅ **Season of Discovery**
- ✅ **Hardcore Classic**
- ✅ **Most popular addons** (tested with ElvUI, Details!, WeakAuras)
- ✅ **All classes and races**

## 📋 Changelog

### Latest Features
- Enhanced honor message system with class detection
- Battleground objective detection and tagging
- Performance optimizations with smart caching
- Configurable settings panel
- Multi-character reputation tracking
- Improved tooltip integration

## 🐛 Known Issues

- Class detection may be limited for players not in your immediate vicinity
- Some BG objectives may not be immediately recognized (will improve over time)
- Reputation tracking requires visiting the reputation panel once per session

## 🆘 Support & Feedback

- **Issues**: Report bugs on our [GitHub Issues page](https://github.com/1broccoli/repute/issues)
- **Feature Requests**: Submit ideas via GitHub Issues with the `enhancement` label

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2025 Broccoli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

See the [LICENSE](https://github.com/1broccoli/repute/blob/main/LICENSE) file for the complete license text.

## 🙏 Acknowledgments

- **Pegga** - Original addon creator
- **Ace3 Team** - Framework and libraries
- **Spy Addon** - Class detection integration
- **WoW Classic Community** - Testing and feedback

---

**⭐ If you find this addon helpful, please consider starring the repository!**


