﻿$Path = '.\Bin\Equihash-NiceHash\nheqminer.exe'
$Uri = "https://github.com/nicehash/nheqminer/releases/download/0.5c/Windows_x64_nheqminer-5c.zip"
$Uri_SubFolder = $true

if((Test-Path $Path) -eq $false)
{
    $FolderName_Old = if($Uri_SubFolder){([IO.FileInfo](Split-Path $Uri -Leaf)).BaseName}else{""}
    $FolderName_New = Split-Path (Split-Path $Path) -Leaf
    $FileName = "$FolderName_New$(([IO.FileInfo](Split-Path $Uri -Leaf)).Extension)"

    try
    {
        if(Test-Path $FileName){Remove-Item $FileName}
        if(Test-Path "$(Split-Path (Split-Path $Path))\$FolderName_New"){Remove-Item "$(Split-Path (Split-Path $Path))\$FolderName_New" -Recurse}
        if($FolderName_Old -ne ""){if(Test-Path "$(Split-Path (Split-Path $Path))\$FolderName_Old"){Remove-Item "$(Split-Path (Split-Path $Path))\$FolderName_Old" -Recurse}}
        Invoke-WebRequest $Uri -OutFile $FileName -UseBasicParsing
        if($FolderName_Old -ne ""){Start-Process "7za" "x $FileName -o$(Split-Path (Split-Path $Path)) -y" -Wait}else{Start-Process "7za" "x $FileName -o$(Split-Path $Path) -y" -Wait}
        if($FolderName_Old -ne ""){Rename-Item "$(Split-Path (Split-Path $Path))\$FolderName_Old" "$FolderName_New"}
    }
    catch
    {
        return
    }
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Port = 3334

[PSCustomObject]@{
    Type = 'CPU'
    Path = $Path
    Arguments = -Join ('-a ', $Port, ' -l $($Pools.Equihash.Host):$($Pools.Equihash.Port) -u $($Pools.Equihash.User)')
    HashRates = [PSCustomObject]@{Equihash = '$($Stats.' + $Name + '_Equihash_HashRate.Day)'}
    API = 'Nheqminer'
    Port = $Port
    Wrap = $false
}