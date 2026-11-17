$ErrorActionPreference = "Continue"
Write-Output "== installation OpenSSH"
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 | Out-Null
Set-Service sshd -StartupType Automatic
Start-Service sshd
Start-Service ssh-agent -ErrorAction SilentlyContinue
New-Item -Force -ItemType Directory C:\ProgramData\ssh | Out-Null
Set-Content -Path C:\ProgramData\ssh\administrators_authorized_keys -Value "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJqbgpYC0l8Ybp3iIw/NqAiVikzXXAmmGemoxmLRqxl hermes-vps" -Encoding ascii
icacls C:\ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F" | Out-Null
if (-not (Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
  New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
}
Write-Output "== sshd:"
Get-Service sshd | Select-Object Status, Name | Format-List
Write-Output "== fini"
