# Git安装指南（Windows）

根据我们的检查，您的系统上似乎没有安装Git。以下是在Windows上安装和配置Git的详细步骤：

## 一、下载Git安装程序

1. 访问Git官方网站：[https://git-scm.com/download/win](https://git-scm.com/download/win)
2. 网站会自动检测您的Windows版本（32位或64位）并提供相应的下载链接
3. 点击下载按钮，获取最新版本的Git安装程序（.exe文件）

## 二、安装Git

1. 找到下载的安装程序文件（通常在"下载"文件夹中），双击运行
2. 您可能会看到用户账户控制提示，点击"是"允许程序运行
3. 在安装向导中，按照以下步骤进行：

   ### 步骤1：选择安装位置
   - 默认安装位置通常是`C:\Program Files\Git`
   - 您可以保持默认或选择其他位置
   - 点击"下一步"

   ### 步骤2：选择组件
   - 建议保持所有默认选项选中
   - 确保选中了：
     - Windows Explorer integration
     - Git Bash Here
     - Git GUI Here
   - 点击"下一步"

   ### 步骤3：选择开始菜单文件夹
   - 保持默认值
   - 点击"下一步"

   ### 步骤4：选择默认编辑器
   - 可以选择您熟悉的文本编辑器
   - 如果不确定，选择"Vim"或"Notepad++"（如果已安装）
   - 点击"下一步"

   ### 步骤5：调整PATH环境变量
   - **这一步非常重要！**
   - 选择"Git from the command line and also from 3rd-party software"
   - 这将确保Git被添加到系统PATH中
   - 点击"下一步"

   ### 步骤6：选择HTTPS传输后端
   - 保持默认选项："Use the OpenSSL library"
   - 点击"下一步"

   ### 步骤7：配置行尾转换
   - 保持默认选项："Checkout Windows-style, commit Unix-style line endings"
   - 点击"下一步"

   ### 步骤8：配置终端模拟器
   - 选择"Use Windows' default console window"
   - 点击"下一步"

   ### 步骤9：配置额外选项
   - 保持默认选项
   - 点击"安装"

4. 等待安装完成，然后点击"完成"

## 三、验证安装

1. 安装完成后，打开命令提示符（CMD）或PowerShell
2. 输入以下命令检查Git是否正确安装：
   ```
   git --version
   ```
3. 如果安装成功，您将看到类似这样的输出：
   ```
   git version 2.39.1.windows.1
   ```

## 四、初始Git配置

安装完成后，建议进行基本配置：

1. 设置您的用户名：
   ```
   git config --global user.name "您的用户名"
   ```

2. 设置您的电子邮件：
   ```
   git config --global user.email "您的邮箱@example.com"
   ```

3. 验证配置：
   ```
   git config --list
   ```

## 五、故障排除

如果安装后仍然无法使用git命令，请尝试以下方法：

1. **重启命令提示符或PowerShell**：有时需要重启终端才能识别新安装的程序

2. **检查PATH环境变量**：
   - 右键点击"此电脑" → "属性" → "高级系统设置" → "环境变量"
   - 在系统变量中找到"Path"并点击"编辑"
   - 确认Git的安装目录（通常是`C:\Program Files\Git\bin`和`C:\Program Files\Git\cmd`）是否已添加
   - 如果没有，点击"新建"添加这些路径
   - 点击"确定"保存更改

3. **使用Git Bash**：
   - 右键点击任意文件夹，选择"Git Bash Here"
   - 在Git Bash中，Git命令应该可以正常工作

## 六、使用Git

安装完成后，您就可以在贪吃蛇游戏项目中使用Git了。以下是一些基本命令：

1. 初始化Git仓库：
   ```
   git init
   ```

2. 添加文件到暂存区：
   ```
   git add .
   ```

3. 提交更改：
   ```
   git commit -m "初始提交 - 贪吃蛇游戏"
   ```

希望这个指南能帮助您成功安装和配置Git！如果您遇到任何问题，请参考Git官方文档或搜索相关帮助。