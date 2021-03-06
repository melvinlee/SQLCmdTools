function Invoke-SqlCmdScript
{
	<#
	.SYNOPSIS
	Execute .sql script given by specific path.

	.DESCRIPTION
	Execute .sql script given by specific path.

	.PARAMETER Path
	Specifies the SQL file path.

	.PARAMETER Server
	Specifies the SQL Server name.

	.PARAMETER Database
	Specifies the SQL Database name.

	.NOTES
	#>
	
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
	(
        [Parameter(ParameterSetName='ByFile',ValueFromPipeline=$true)]
		[string[]]$File,

		[Parameter(Mandatory,ParameterSetName='ByPath')]
		[ValidateNotNullOrEmpty()]
		[string]$Path,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Server,

		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Database
	)

        Begin {
        
            $outputArray = @()
        }

        Process {

            If ($PSCmdlet.ShouldProcess("from Path[$Path] on host:$Server database:\$Database","Executing SQL")) 
            {
                
                $pattern = "*.sql"
                $outputLog  = "$Database.log"
                
                Write-Verbose "Outputlog: $outputLog"

                If($PSCmdlet.ParameterSetName -eq "ByPath")
                {
                    
                    Try{

                        $files = Get-ChildItem $Path $pattern -Recurse -Force

                        foreach ($sqlFile in $files)
                        {         

                            $outputArray += Use-SqlCmd -File $sqlFile.FullName -Server $Server -Database $Database

                        }
                        
                    }Catch{

                        Write-Error "Error on Invoke-SqlCmdScript. $_.Exception.Message"

                    }
                    
                }else{

                    $outputArray += Use-SqlCmd -File $file -Server $Server -Database $Database
                       
                }
                
               # $scriptOutput | out-file $outputLog -Encoding ascii
            }
        }

        End {
            
            Write-Output $outputArray
        }
    
}