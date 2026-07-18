import-module servermanager
add-windowsfeature web-server -Includeallsubfeature
Set-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value "This is the server $env:computername. This is a test page for the web server role."