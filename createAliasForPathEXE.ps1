﻿function Export-AliasWithEXEInPATH
{
    $aliasDict = @{}
    $existingAlias = Get-Alias | ForEach-Object {$_.Name}
    foreach($aliasName in $existingAlias)
    {
        $aliasDict.Add($aliasName,"")
    }
    $pathDirectories = $env:PATH.Split(';') | Where-Object {($_ -ne "") -and (Test-Path $_ )}
    foreach($pathDir in $pathDirectories)
    {
        $result = Get-ChildItem (Join-Path $pathDir "*") -Include *.exe | 
            ForEach-Object {
                                Write-Host "Checking" $_.BaseName "for aliasing"
                                If(-Not $aliasDict.ContainsKey($_.BaseName))
                                {
                                    $alias = $_.BaseName.ToString()
                                    $for = $_.Name
                                    Set-Alias -Name $alias -Value $for -Verbose -Scope "Global"
                                }
                            }             

    }

    Export-Alias $aliasesPath
}