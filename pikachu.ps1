# Author: Emre Köybaşı

$pikachu = @"
	`;-.          ___,
  	`.`\_...._/`.-"`
    	\        /      ,
    	/()   () \    .' `-._
   	|)  .    ()\  /   _.'
   	\  -'-     ,; '. <   SMTP User ButeForce
    	;.__     ,;|   >        (POWERSHEL)
   	/ ,    / ,  |.-'.-'
  	(_/    (_/ ,;|.<`
    	\    ,     ;-`
     	>   \    /
    	(_,-'`> .'
Pikachu   (_,'

"@

Write-Output $pikachu
Start-Sleep -Seconds 1
Write-Output "`n [+] Pikachu-SMTP starting!`n"

if ($args.Length -ne 2) {
    Write-Output "`n Usage: ./pikachu <target-ip> <wordlist> `n"
    exit
}

$target_ip = $args[0]
$user_file = $args[1]

if (-not (Test-Path $user_file)) {
    Write-Output "`n[!] File Not Found....exiting now..`n"
    exit
}

function brute($ip, $word) {
    $s = New-Object System.Net.Sockets.TcpClient
    $s.Connect($ip, 25)
    $stream = $s.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.AutoFlush = $true
    $reader.ReadLine() | Out-Null
    $writer.WriteLine("VRFY $word")
    $writer.Flush()
    $answer = $reader.ReadLine()
    if (-not ($answer.ToLower()).Contains("unknown")) {
        Write-Output "[+] $word does exist"
    }
    $s.Close()
}

Get-Content $user_file | ForEach-Object {
    $user = $_.Trim()
    brute $target_ip $user
}
