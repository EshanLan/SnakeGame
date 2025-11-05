#!/usr/bin/env pwsh
# Git用户名和邮箱配置脚本

Write-Host "=== Git用户信息配置工具 ==="
Write-Host "此脚本将帮助您配置Git提交所需的用户名和邮箱信息"
Write-Host ""

function Get-CurrentGitConfig {
    <#
    .SYNOPSIS
    获取当前Git用户名和邮箱配置
    #>
    try {
        $userName = git config --global user.name 2>$null
        $userEmail = git config --global user.email 2>$null
        
        return @{
            UserName = $userName
            UserEmail = $userEmail
        }
    } catch {
        Write-Host "获取Git配置时出错: $_"
        return $null
    }
}

function Set-GitUserConfig {
    <#
    .SYNOPSIS
    设置Git用户名和邮箱
    #>
    param(
        [string]$UserName,
        [string]$UserEmail
    )
    
    try {
        # 设置用户名
        git config --global user.name "$UserName"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ 用户名设置成功: $UserName"
        } else {
            Write-Host "❌ 用户名设置失败"
            return $false
        }
        
        # 设置邮箱
        git config --global user.email "$UserEmail"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ 邮箱设置成功: $UserEmail"
            return $true
        } else {
            Write-Host "❌ 邮箱设置失败"
            return $false
        }
    } catch {
        Write-Host "设置Git配置时出错: $_"
        return $false
    }
}

# 检查Git是否可用
try {
    $gitVersion = git --version 2>$null
    if (-not $gitVersion) {
        Write-Host "❌ Git命令不可用，请先安装和配置Git"
        Write-Host "请参考目录中的 GIT_INSTALL_GUIDE.md 文件"
        Read-Host "按Enter键退出..."
        exit
    }
} catch {
    Write-Host "❌ 检测Git时出错: $_"
    Read-Host "按Enter键退出..."
    exit
}

Write-Host "Git版本: $gitVersion"
Write-Host ""

# 检查当前配置
Write-Host "当前Git用户配置:"
$currentConfig = Get-CurrentGitConfig

if ($currentConfig) {
    Write-Host "   用户名: $(if ($currentConfig.UserName) {"✅ $($currentConfig.UserName)"} else {"❌ 未设置"})"
    Write-Host "   邮箱: $(if ($currentConfig.UserEmail) {"✅ $($currentConfig.UserEmail)"} else {"❌ 未设置"})"
} else {
    Write-Host "   无法获取当前配置"
}

Write-Host ""

# 如果已有配置，询问是否需要修改
if ($currentConfig -and $currentConfig.UserName -and $currentConfig.UserEmail) {
    Write-Host "检测到您已配置了Git用户信息，还需要修改吗？"
    $response = Read-Host "输入 'y' 修改，其他键退出"
    
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host ""
        Write-Host "保持当前配置不变，退出脚本。"
        Read-Host "按Enter键退出..."
        exit
    }
    
    Write-Host ""
}

# 提示配置信息的用途
Write-Host "提示："
Write-Host "1. 用户名和邮箱将显示在您的Git提交记录中"
Write-Host "2. 邮箱最好使用您在代码托管平台(如GitHub)注册的邮箱"
Write-Host "3. 这些信息仅存储在您的本地计算机上"
Write-Host ""

# 获取新的用户信息
$newUserName = Read-Host -Prompt "请输入您的Git用户名 (例如: YourName)"
while (-not $newUserName.Trim()) {
    Write-Host "用户名不能为空!"
    $newUserName = Read-Host -Prompt "请输入您的Git用户名"
}

$newUserEmail = Read-Host -Prompt "请输入您的Git邮箱 (例如: your.email@example.com)"
while (-not $newUserEmail.Trim() -or (-not $newUserEmail -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')) {
    Write-Host "请输入有效的邮箱地址!"
    $newUserEmail = Read-Host -Prompt "请输入您的Git邮箱"
}

Write-Host ""
Write-Host "确认设置:"
Write-Host "用户名: $newUserName"
Write-Host "邮箱: $newUserEmail"
$confirm = Read-Host "确认设置？(y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host ""
    Write-Host "取消设置，退出脚本。"
    Read-Host "按Enter键退出..."
    exit
}

Write-Host ""
Write-Host "正在设置Git用户信息..."

# 设置用户信息
$success = Set-GitUserConfig -UserName $newUserName -UserEmail $newUserEmail

if ($success) {
    Write-Host ""
    Write-Host "✅ Git用户信息配置完成!"
    Write-Host "您现在可以正常提交代码了。"
    
    # 验证设置
    Write-Host ""
    Write-Host "验证配置:"
    $updatedConfig = Get-CurrentGitConfig
    if ($updatedConfig) {
        Write-Host "   用户名: $($updatedConfig.UserName)"
        Write-Host "   邮箱: $($updatedConfig.UserEmail)"
    }
} else {
    Write-Host ""
    Write-Host "❌ 配置失败，请检查您的Git安装和权限"
}

Write-Host ""
Write-Host "提示: 如需单独设置某个项目的用户信息，可以在项目目录下运行以下命令："
Write-Host "   git config user.name \"YourName\" (不带 --global 参数)"
Write-Host "   git config user.email \"your.email@example.com\""

Write-Host ""
Read-Host "按Enter键退出..."