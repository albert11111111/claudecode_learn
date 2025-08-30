# WSL与Windows miniconda3兼容配置文档

## 配置概述

本配置实现了在WSL(Linux子系统)中无缝使用Windows上的miniconda3环境，特别是`timeseries_anomaly`环境。

## 配置详情

### 1. 环境路径映射

**Windows环境路径：**
- miniconda3根目录：`C:\Users\13370\miniconda3`
- timeseries_anomaly环境：`C:\Users\13370\miniconda3\envs\timeseries_anomaly`
- WSL路径：`/mnt/c/Users/13370/miniconda3/`

**关键可执行文件：**
- Python解释器：`/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe`
- conda命令：`/mnt/c/Users/13370/miniconda3/Scripts/conda.exe`
- pip命令：`/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/Scripts/pip.exe`

### 2. 配置文件修改

**修改文件：** `~/.bashrc` (位于/home/yrx20040502/.bashrc)

**添加内容：**
```bash
# Windows miniconda3 configuration
export PATH="/mnt/c/Users/13370/miniconda3/Scripts:$PATH"

# 快捷命令别名
alias conda-win="/mnt/c/Users/13370/miniconda3/Scripts/conda.exe"
alias python-ts="/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe"
alias pip-ts="/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/Scripts/pip.exe"
alias jupyter-ts="/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/Scripts/jupyter.exe"
alias activate-ts="source /mnt/c/Users/13370/miniconda3/Scripts/activate timeseries_anomaly"
```

### 3. 命令使用方式

#### 运行Python代码
```bash
# 直接运行
/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe LSM_.py

# 使用别名（需先source ~/.bashrc）
python-ts LSM_.py
```

#### 包管理
```bash
# 查看已安装包
/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/Scripts/pip.exe list

# 安装新包
/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/Scripts/pip.exe install numpy
/mnt/c/Users/13370/miniconda3/Scripts/conda.exe install -n timeseries_anomaly numpy

# 使用别名
pip-ts install numpy
conda-ts install numpy
```

#### 环境管理
```bash
# 列出环境
/mnt/c/Users/13370/miniconda3/Scripts/conda.exe env list

# 激活环境
source /mnt/c/Users/13370/miniconda3/Scripts/activate timeseries_anomaly
```

### 4. 验证配置

**验证Python版本：**
```bash
/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe --version
# 输出：Python 3.8.20
```

**验证conda版本：**
```bash
/mnt/c/Users/13370/miniconda3/Scripts/conda.exe --version
# 输出：conda 25.5.1
```

### 5. 注意事项

1. **路径差异**：Windows路径使用反斜杠，WSL使用正斜杠
2. **权限问题**：确保WSL有访问Windows文件的权限
3. **环境隔离**：此配置仅影响当前用户，不影响系统其他部分
4. **重启生效**：修改.bashrc后需要`source ~/.bashrc`或重新打开终端

### 6. 故障排除

**如果命令找不到：**
- 确认路径存在：`ls -la /mnt/c/Users/13370/miniconda3/`
- 检查文件权限：`ls -la /mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe`
- 重新加载配置：`source ~/.bashrc`

**如果包安装失败：**
- 检查网络连接
- 确认conda/pip可执行
- 尝试使用管理员权限运行