#!/usr/bin/env pwsh
# Git安装和配置验证脚本

Write-Host "=== Git安装和配置验证工具 ==="
Write-Host "此脚本将帮助您验证Git的安装状态和基本配置"
Write-Host ""

function Test-GitCommand {
    <#
    .SYNOPSIS
    测试git命令是否可用并返回版本信息
    #>
    try {
        # 尝试在不同的PowerShell上下文中运行git命令
        $gitVersion = git --version 2>$null
        if ($gitVersion) {
            return @{
                Success = $true
                Message = $gitVersion
                Path = (Get-Command git -ErrorAction SilentlyContinue).Source
            }
        }
        return @{
            Success = $false
            Message = "git命令不可用，请检查PATH配置"
            Path = $null
        }
    } catch {
        return @{
            Success = $false
            Message = "运行git命令时出错: $_"
            Path = $null
        }
    }
}

function Test-GitPath {
    <#
    .SYNOPSIS
    检查PATH环境变量中是否包含Git相关路径
    #>
    $paths = $env:PATH -split ';'
    $gitPaths = @()
    
    foreach ($path in $paths) {
        if ($path -match 'git' -or (Test-Path "$path\git.exe")) {
            $gitPaths += $path
        }
    }
    
    return $gitPaths
}

function Get-GitConfig {
    <#
    .SYNOPSIS
    获取Git的基本配置信息
    #>
    try {
        $userName = git config --global user.name 2>$null
        $userEmail = git config --global user.email 2>$null
        $coreEditor = git config --global core.editor 2>$null
        $coreAutoCRLF = git config --global core.autocrlf 2>$null
        
        return @{
            UserName = $userName
            UserEmail = $userEmail
            CoreEditor = $coreEditor
            CoreAutoCRLF = $coreAutoCRLF
        }
    } catch {
        Write-Host "获取Git配置时出错: $_"
        return $null
    }
}

# 1. 测试git命令
Write-Host "1. 测试git命令可用性..."
$gitTest = Test-GitCommand

if ($gitTest.Success) {
    Write-Host "✅ git命令可用!"
    Write-Host "   版本: $($gitTest.Message)"
    Write-Host "   路径: $($gitTest.Path)"
} else {
    Write-Host "❌ $($gitTest.Message)"
    Write-Host "   请参考 ADD_GIT_TO_PATH.md 文件进行配置"
}

Write-Host ""

# 2. 检查PATH环境变量
Write-Host "2. 检查PATH中的Git路径..."
$gitPathsInPath = Test-GitPath

if ($gitPathsInPath.Count -gt 0) {
    Write-Host "✅ 在PATH中找到以下Git相关路径:"
    foreach ($path in $gitPathsInPath) {
        Write-Host "   - $path"
    }
} else {
    Write-Host "❌ 在PATH中未找到Git相关路径"
    
    # 尝试查找Git安装位置
    $commonGitExePaths = @(
        "C:\Program Files\Git\bin\git.exe",
        "C:\Program Files (x86)\Git\bin\git.exe",
        "$env:USERPROFILE\AppData\Local\Programs\Git\bin\git.exe"
    )
    
    foreach ($gitExePath in $commonGitExePaths) {
        if (Test-Path $gitExePath) {
            $gitBinDir = Split-Path -Parent $gitExePath
            Write-Host "   发现Git已安装但未添加到PATH: $gitBinDir"
            Write-Host "   请将此路径添加到系统PATH中"
            break
        }
    }
}

Write-Host ""

# 3. 检查Git配置
Write-Host "3. 检查Git基本配置..."
if ($gitTest.Success) {
    $gitConfig = Get-GitConfig
    
    if ($gitConfig) {
        Write-Host "   用户名(User.Name): $(if ($gitConfig.UserName) {"✅ $($gitConfig.UserName)"} else {"❌ 未设置"})"
        Write-Host "   邮箱(User.Email): $(if ($gitConfig.UserEmail) {"✅ $($gitConfig.UserEmail)"} else {"❌ 未设置"})"
        Write-Host "   编辑器(Core.Editor): $(if ($gitConfig.CoreEditor) {"✅ $($gitConfig.CoreEditor)"} else {"❌ 未设置"})"
        Write-Host "   行尾处理(Core.AutoCRLF): $(if ($gitConfig.CoreAutoCRLF) {"✅ $($gitConfig.CoreAutoCRLF)"} else {"❌ 未设置"})"
        
        if (-not $gitConfig.UserName -or -not $gitConfig.UserEmail) {
            Write-Host ""
            Write-Host "⚠️  建议设置Git用户名和邮箱（首次提交前必须）"
            Write-Host "   运行以下命令进行设置："
            Write-Host "   git config --global user.name \"您的名字\""
            Write-Host "   git config --global user.email \"您的邮箱@example.com\""
        }
    }
} else {
    Write-Host "   无法检查配置，因为git命令不可用"
}

Write-Host ""

# 4. 测试基本Git操作（如果git命令可用）
if ($gitTest.Success) {
    Write-Host "4. 测试基本Git操作..."
    try {
        # 尝试列出所有可用的Git命令
        $commands = git help -a 2>$null
        if ($commands -and $commands.Count -gt 10) {
            Write-Host "✅ Git命令集正常工作"
        } else {
            Write-Host "⚠️  Git命令响应不完整"
        }
    } catch {
        Write-Host "❌ Git操作测试失败: $_"
    }
    
    Write-Host ""
}

# 5. 总结
Write-Host "=== 验证总结 ==="

if ($gitTest.Success) {
    Write-Host "✅ Git安装验证成功!"
    
    # 检查是否有任何配置缺失
    if ($gitConfig -and (-not $gitConfig.UserName -or -not $gitConfig.UserEmail)) {
        Write-Host "⚠️  但建议您设置Git用户名和邮箱，以避免后续提交问题"
    }
    
    Write-Host ""
    Write-Host "您现在可以正常使用Git进行以下操作："
    Write-Host "   - 创建和克隆仓库"
    Write-Host "   - 提交更改"
    Write-Host "   - 推送到远程仓库"
    Write-Host "   - 分支管理"
    Write-Host "   - 解决合并冲突"
} else {
    Write-Host "❌ Git验证失败"
    Write-Host ""
    Write-Host "请按照以下步骤解决问题："
    Write-Host "1. 确认Git已正确安装（参考GIT_INSTALL_GUIDE.md）"
    Write-Host "2. 确保Git路径已添加到系统PATH（参考ADD_GIT_TO_PATH.md）"
    Write-Host "3. 重启所有命令提示符或PowerShell窗口"
    Write-Host "4. 再次运行此验证脚本"
}

Write-Host ""
Write-Host "=== 故障排除 ==="
Write-Host "如果遇到问题，请尝试："
Write-Host "1. 以管理员身份运行命令提示符/PowerShell"
Write-Host "2. 检查防病毒软件是否阻止了Git"
Write-Host "3. 确保没有其他程序占用了git命令别名"
Write-Host "4. 尝试重新安装Git，并确保勾选'Add Git to PATH'选项"

Write-Host ""
Write-Host "脚本执行完成。按任意键退出..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null