$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = $currentPath + "\.."

# Remove module if already exists
Get-Module SqlCmdTools | Remove-Module -Force

# Import the module
Import-Module $rootPath\SqlCmdTools.psm1 -Force

Describe 'Invoke-SqlCmdScript Tests'{

    Context "Parameter Validation"{

        It "Shold throw exception when server parameter missing"{
            { .\Invoke-SqlCmsScript -Path "" -Database "test"} | Should Throw
        }

        It "Shold throw exception when database parameter missing"{
            { .\Invoke-SqlCmsScript -Path "" -Server "test"} | Should Throw
        }
    }
}