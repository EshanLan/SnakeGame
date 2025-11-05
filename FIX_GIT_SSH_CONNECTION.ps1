# Git SSH连接问题解决方案脚本
# 解决 'ssh: connect to host github.com port 22: Connection refused' 错误

Write-Host "===== Git SSH连接问题解决方案 ====="
Write-Host "此脚本将帮助您诊断和解决GitHub SSH连接被拒绝的问题。"
Write-Host "\n"

# 1. 检查SSH配置和测试连接
Write-Host "[1] 测试SSH连接..."
Write-Host "正在尝试连接到GitHub的SSH服务..."
Write-Host "\n"

try {
    # 测试SSH连接到GitHub
    $testResult = ssh -T git@github.com -v 2>&1
    Write-Host "SSH连接测试结果:" -ForegroundColor Yellow
    Write-Host "$testResult" -ForegroundColor Gray
    Write-Host "\n"
} catch {
    Write-Host "SSH连接测试失败: $_" -ForegroundColor Red
    Write-Host "\n"
}

# 2. 提供解决方法选项
Write-Host "[2] 解决方案选项:"
Write-Host "1. 使用HTTPS代替SSH协议（最常用解决方案）"
Write-Host "2. 配置SSH使用443端口（可能绕过防火墙限制）"
Write-Host "3. 检查本地防火墙设置"
Write-Host "4. 生成/重置SSH密钥"
Write-Host "\n"

# 3. 自动执行HTTPS替代方案的命令示例
Write-Host "[3] HTTPS替代方案命令:"
Write-Host "以下是将现有仓库从SSH切换到HTTPS的命令:"
Write-Host "git remote set-url origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git" -ForegroundColor Green
Write-Host "\n"

# 4. SSH端口443配置方法
Write-Host "[4] 配置SSH使用443端口:"
Write-Host "创建或编辑SSH配置文件: ~/.ssh/config 并添加以下内容:"
Write-Host "Host github.com" -ForegroundColor Green
Write-Host "  Hostname ssh.github.com" -ForegroundColor Green
Write-Host "  Port 443" -ForegroundColor Green
Write-Host "\n"

# 5. 检查防火墙设置
Write-Host "[5] 防火墙检查建议:"
Write-Host "请确保您的防火墙没有阻止以下连接:"
Write-Host "- TCP端口22 (SSH) 或 443 (HTTPS) 到 github.com"
Write-Host "- 如果在企业网络中，请联系IT部门确认网络策略" -ForegroundColor Yellow
Write-Host "\n"

# 6. 生成新SSH密钥的步骤
Write-Host "[6] 生成新SSH密钥的命令:"
Write-Host "如果需要生成新的SSH密钥，请运行:"
Write-Host "ssh-keygen -t ed25519 -C \"your_email@example.com\"" -ForegroundColor Green
Write-Host "生成后，需要将公钥添加到您的GitHub账户中" -ForegroundColor Yellow
Write-Host "\n"

# 7. 当前仓库的远程URL检查
Write-Host "[7] 检查当前仓库的远程URL配置:"
Write-Host "运行以下命令查看当前仓库的远程URL:"
Write-Host "git remote -v" -ForegroundColor Green
Write-Host "\n"

# 8. 提供快速修复选项 - 创建SSH配置文件使用443端口
Write-Host "[8] 自动修复选项: 创建SSH配置使用443端口"
Write-Host "要自动创建SSH配置文件以使用443端口，请按Enter键..."
Read-Host

# 创建SSH目录
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path -Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    Write-Host "已创建SSH目录: $sshDir" -ForegroundColor Green
}

# 创建或更新SSH配置文件
$sshConfig = "$sshDir\config"
$configContent = @"
Host github.com
  Hostname ssh.github.com
  Port 443
  User git
"@

Set-Content -Path $sshConfig -Value $configContent -Force
Write-Host "已创建SSH配置文件，配置GitHub使用443端口" -ForegroundColor Green
Write-Host "配置文件路径: $sshConfig" -ForegroundColor Yellow
Write-Host "\n"

# 9. 测试新的配置
Write-Host "[9] 测试新的SSH配置..."
Write-Host "正在使用新配置测试SSH连接..."
Write-Host "\n"

try {
    $newTestResult = ssh -T git@github.com 2>&1
    Write-Host "新配置测试结果:" -ForegroundColor Yellow
    Write-Host "$newTestResult" -ForegroundColor Gray
    Write-Host "\n"
} catch {
    Write-Host "测试失败: $_" -ForegroundColor Red
    Write-Host "\n"
}

# 10. 总结和建议
Write-Host "===== 总结和建议 =====" -ForegroundColor Cyan
Write-Host "1. 如果SSH连接仍然失败，建议尝试使用HTTPS协议"
Write-Host "2. 企业网络中可能需要使用VPN或联系IT部门"
Write-Host "3. 可以通过git config --global http.proxy 设置HTTP代理"
Write-Host "4. 如需更多帮助，请查看GitHub官方文档: https://docs.github.com/cn/authentication/troubleshooting-ssh"
Write-Host "\n"

Write-Host "解决方案脚本执行完成。按任意键退出..."
Read-Host