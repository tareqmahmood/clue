# Clue - Linux Command Line Tips Utility

![Made for: Undergrads](https://img.shields.io/badge/Made%20For-Undergrads-green?style=flat-square&logo=gnubash) ![Warning: Vibe Coding](https://img.shields.io/badge/Warning-Vibe%20Coding-yellow?style=flat-square&logo=linux)

A bash-only Linux command line utility that displays helpful Linux tips automatically as you work, helping you learn new commands and improve your terminal skills.

## 🚀 Quick Install

Install clue with a single command:

```bash
curl -s https://tareqmahmood.github.io/clue/install.sh | bash
```

After installation, restart your terminal or run:
```bash
source ~/.bashrc
```

## 📋 Features

- **Automatic Tips**: Shows helpful Linux tips every 5 commands (configurable)
- **Multiple Difficulty Levels**: Beginner, Intermediate, Advanced, and All modes
- **300+ Tips**: 100 tips for each difficulty level covering essential Linux commands.
- **Configurable**: Customize interval and difficulty level
- **Manual Mode**: View tips on demand
- **Clean Uninstall**: Easy removal with backup

## 🎯 How It Works

Once installed, clue integrates with your bash prompt and automatically displays tips based on your command usage:

```bash
$ ls -la
total 24
drwxr-xr-x 3 user user 4096 Sep  7 10:30 .
drwxr-xr-x 5 user user 4096 Sep  7 10:29 ..
-rw-r--r-- 1 user user  123 Sep  7 10:30 file.txt

$ cd projects

$ pwd
/home/user/projects

$ git status
On branch main
nothing to commit, working tree clean

$ ls

[clue tip #23 - beginner]
Use `head` to see the first 10 lines of a file. Great for checking file headers or previewing content.
Example: head filename.txt

$ 
```

## 🔧 Usage

### Automatic Mode
Tips appear automatically every 5 commands (configurable). No action needed!

### Manual Mode
```bash
# Show random tip from current mode
clue

# Show tip from specific difficulty level
clue -m beg           # Beginner tips
clue -m int           # Intermediate tips
clue -m adv           # Advanced tips
clue -m all           # Random tip from any level

# Full names also work
clue -m beginner
clue -m intermediate
clue -m advanced

# Show specific tip by number
clue -i 15            # Show tip #15 from current mode

# Help
clue -h
```

## ⚙️ Configuration

Edit `~/.clue/config.sh` to customize settings:

```bash
#!/bin/bash
# clue configuration

# Interval between tips (number of commands)
CLUE_INTERVAL=20

# Default mode (beg, int, adv, all)
# Aliases: beginner, intermediate, advanced, all
CLUE_MODE=beg
```

### Configuration Options

- **CLUE_INTERVAL**: How many commands between automatic tips (default: 5)
- **CLUE_MODE**: Default difficulty level
  - `beg` (or `beginner`): Basic file operations, navigation, text viewing
  - `int` (or `intermediate`): Advanced searching, text processing, system tools
  - `adv` (or `advanced`): Complex scripting, process management, network tools
  - `all`: Random tips from any difficulty level

## 📖 Sample Tips

### Beginner Level
```
[clue tip #12 - beginner]
Use `ls -lh` to see human-readable file sizes instead of raw bytes. The -h flag makes output much more readable.
Example: ls -lh
```

### Intermediate Level  
```
[clue tip #45 - intermediate]
Use `find` with `-type f` to search only for files, or `-type d` for directories. Much more precise than basic find.
Example: find /path -type f -name "*.txt"
```

### Advanced Level
```
[clue tip #78 - advanced]
Process substitution with `<()` lets you use command output as if it were a file. Powerful for complex pipelines.
Example: diff <(sort file1) <(sort file2)
```

## 🛠️ Installation Options

### Remote Installation (Recommended)
```bash
curl -s https://tareqmahmood.github.io/clue/install.sh | bash
```

### Local Installation (Development)
```bash
git clone https://github.com/tareqmahmood/clue.git
cd clue
./install.sh local
```

## 📁 File Structure

After installation, clue creates the following structure:

```
~/.clue/
├── clue.sh          # Main script
├── config.sh        # Configuration file
├── beginner.txt     # Beginner tips
├── intermediate.txt # Intermediate tips
├── advanced.txt     # Advanced tips
└── uninstall.sh     # Uninstall script
```

## 🗑️ Uninstall

To completely remove clue from your system:

```bash
~/.clue/uninstall.sh
```

This will:
- Remove all clue files from `~/.clue`
- Remove integration from `.bashrc` 
- Create a backup of your original `.bashrc`

Restart `bash` to see the effect.

## 🔍 What's Included

### Beginner Tips
- File operations: `ls`, `cp`, `mv`, `rm`, `mkdir`
- Text viewing: `cat`, `less`, `head`, `tail`
- Navigation: `cd`, `pwd`, directory operations
- System info: `whoami`, `date`, `df`, `free`
- Basic permissions: `chmod`, `chown`
- Archives: `zip`, `tar` basics

### Intermediate Tips
- Advanced find: Complex search patterns
- Text processing: `awk`, `sed`, `grep` with options
- File comparison: `diff`, `comm`, `cmp`
- Compression: `gzip`, advanced `tar`
- Network tools: `rsync`, `nc`, `ss`, `lsof`
- System analysis: `lscpu`, `lsusb`, `dmesg`
- Process control: `screen`, `tmux`, `jobs`

### Advanced Tips
- Complex text processing: Advanced `awk`, `sed`, `perl`
- Process substitution: `<()`, `>()`, named pipes
- Bash scripting: Functions, arrays, parameter expansion
- Performance: `parallel`, optimized `xargs`
- JSON/XML: `jq`, `xmllint`
- Network security: `nmap`, `tcpdump`, `iptables`
- Containers: `docker`, `kubernetes` basics

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Submit new tips
- Improve existing descriptions
- Fix bugs
- Enhance documentation

## 📄 License

This project is open source. Feel free to use, modify, and distribute.

## 🐛 Troubleshooting

### Tips not appearing?
1. Make sure you've sourced your bashrc: `source ~/.bashrc`
2. Check if clue integration exists: `grep -A 5 "BEGIN CLUE" ~/.bashrc`
3. Verify counter is working: `echo $CLUE_COUNTER`

### Reset configuration?
```bash
rm ~/.clue/config.sh
curl -s https://tareqmahmood.github.io/clue/uninstall.sh | bash
curl -s https://tareqmahmood.github.io/clue/install.sh | bash
```

### Manual tip testing?
```bash
~/.clue/clue.sh -m beginner
```

---

**Happy learning!** 🎓 Clue helps you discover new Linux commands naturally as you work.