#!/usr/bin/env pwsh
# 查找并使用完整路径访问Git的PowerShell脚本

Write-Host "=== Git查找和运行助手 ==="
Write-Host "正在搜索系统中的Git安装位置..."
Write-Host ""

# 常见的Git安装路径列表
$commonGitPaths = @(
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\bin\git.exe",
    "$env:USERPROFILE\AppData\Local\Programs\Git\bin\git.exe",
    "C:\Git\bin\git.exe",
    "C:\Program Files\Git\cmd\git.exe",
    "C:\Program Files (x86)\Git\cmd\git.exe",
    "$env:USERPROFILE\AppData\Local\Programs\Git\cmd\git.exe"
)

# 存储找到的Git路径
$foundGitPaths = @()

# 检查常见路径
foreach ($path in $commonGitPaths) {
    if (Test-Path -Path $path) {
        $foundGitPaths += $path
        Write-Host "✅ 找到Git: $path"
    }
}

# 如果没有在常见路径中找到，尝试简单的Windows搜索
if ($foundGitPaths.Count -eq 0) {
    Write-Host "❌ 未在常见路径中找到Git"
    Write-Host "正在尝试搜索系统中的git.exe..."
    
    try {
        # 简单的搜索方法
        $searchResults = Get-ChildItem -Path "C:\" -Recurse -Filter "git.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName | Sort-Object
        
        foreach ($result in $searchResults) {
            $foundGitPaths += $result
            Write-Host "✅ 找到Git: $result"
        }
        
        if ($foundGitPaths.Count -eq 0) {
            Write-Host "❌ 系统搜索也未找到git.exe"
            Write-Host "建议：请按照GIT_INSTALL_GUIDE.md文件中的步骤安装Git"
        }
    } catch {
        Write-Host "❌ 搜索过程中发生错误：$_"
    }
}

Write-Host ""

# 如果找到Git，提供使用完整路径的示例
if ($foundGitPaths.Count -gt 0) {
    Write-Host "=== 使用Git完整路径的方法 ==="
    Write-Host "1. 直接使用完整路径运行Git命令："
    Write-Host "   例如：& '$($foundGitPaths[0])' --version"
    Write-Host ""
    
    Write-Host "2. 测试第一个找到的Git版本："
    try {
        Write-Host "正在测试: & '$($foundGitPaths[0])' --version"
        $gitVersion = & "$($foundGitPaths[0])" --version
        Write-Host "✅ Git版本: $gitVersion"
    } catch {
        Write-Host "❌ 运行Git命令时出错：$_"
    }
    
    Write-Host ""
    Write-Host "3. 临时设置Git路径："
    $gitDir = Split-Path -Path $foundGitPaths[0] -Parent
    Write-Host "   将此命令复制到PowerShell中运行："
    Write-Host "   `$env:PATH += ';$gitDir'"
    Write-Host "   然后您就可以直接使用 'git' 命令了"
    Write-Host ""
}

Write-Host "=== 使用说明 ==="
Write-Host "1. 如果您看到多个Git安装，请选择一个最适合的版本使用"
Write-Host "2. 要永久使用git命令，请参考 ADD_GIT_TO_PATH.md 文件中的步骤"
Write-Host "3. 如果您还没有安装Git，请参考 GIT_INSTALL_GUIDE.md 文件"
Write-Host ""
Write-Host "脚本执行完成。按任意键退出..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null