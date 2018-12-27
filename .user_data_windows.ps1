<powershell>
if ([Environment]::OSVersion.Version -ge (new-object 'Version' 6,1)) {
   New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -Action Allow -Protocol TCP  -EdgeTraversalPolicy Allow -LocalPort 5985
} else {
    netsh advfirewall firewall add rule name="Allow WinRM" dir=in protocol=TCP localport=5985 action=allow remoteip=any localip=any profile=any
}
# winrm set winrm/config/service/auth '@{Basic="true"}'
# winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm quickconfig -q
Set-ExecutionPolicy Unrestricted -force
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
net stop winrm
sc config winrm start=auto
net start winrm
$admin = [adsi]("WinNT://./Administrator, user")
$admin.psbase.invoke("SetPassword", "password@123")
</powershell>