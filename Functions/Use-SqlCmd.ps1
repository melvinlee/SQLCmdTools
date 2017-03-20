function Use-SqlCmd
{
    Param(
  		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string[]]$File,

        [Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Server,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Database
    )

    $cmd = "sqlcmd -S $Server -d $Database -I -i ""$($file)"""
    
    Write-Verbose "Executing: $cmd"
    
    $outputObject = New-Object -TypeName PSObject
    $outputObject | Add-Member -Name 'SqlFile' -MemberType Noteproperty -Value "$file"
    $outputObject | Add-Member -Name 'Server' -MemberType Noteproperty -Value "$Server"
    $outputObject | Add-Member -Name 'Database' -MemberType Noteproperty -Value "$Database"
                        
    & sqlcmd -S $Server -d $Database -I -i $($File)  | Tee-Object -Variable scriptOutput | Out-Null
    
    $isError = $false

    if($scriptOutput -Match "Level 16"){
        $isError = $true
    }

    $outputObject | Add-Member -Name 'Error' -MemberType Noteproperty -Value $isError
    $outputObject | Add-Member -Name 'OutputLog' -MemberType Noteproperty -Value "$scriptOutput"

    Write-Verbose "Output: $scriptOutput"

    $scriptOutput = ""

    return $outputObject

}