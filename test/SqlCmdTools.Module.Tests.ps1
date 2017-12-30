$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = $currentPath + "\.."
$functionPath = "$rootPath\Functions\" 

$module = 'SqlCmdTools'

Describe "$module Module Tests"  {

  Context 'Module Setup' {
    It "has the root module $module.psm1" {
      "$rootPath\$module.psm1" | Should Exist
    }

    It "has the a manifest file of $module.psm1" {
      "$rootPath\$module.psd1" | Should Exist
      "$rootPath\$module.psd1" | Should FileContentMatch "$module.psm1"
    }

    It "$module is valid PowerShell code" {
      $psFile = Get-Content -Path "$rootPath\$module.psm1" `
                            -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should Be 0
    }
  }

  $functions = ('Invoke-SqlCmdScript'
               )

  foreach ($function in $functions)
  {
  
    Context "Test Function $function" {
      
      It "$function.ps1 should exist" {
        "$functionPath\$function.ps1" | Should Exist
      }
    
      It "$function.ps1 should be an advanced function" {
        "$functionPath\$function.ps1" | Should FileContentMatch 'function'
        "$functionPath\$function.ps1" | Should FileContentMatch 'cmdletbinding'
        "$functionPath\$function.ps1" | Should FileContentMatch 'param'
      }
      
      It "$function.ps1 should contain Write-Verbose blocks" {
        "$functionPath\$function.ps1" | Should FileContentMatch 'Write-Verbose'
      }
    
      It "$function.ps1 is valid PowerShell code" {
        $psFile = Get-Content -Path "$functionPath\$function.ps1" `
                              -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
        $errors.Count | Should Be 0
      }

    
    } # Context "Test Function $function"
  
  } # foreach ($function in $functions)

}


