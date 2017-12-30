[![Build status](https://ci.appveyor.com/api/projects/status/my5091jr0yhcf32w?svg=true)](https://ci.appveyor.com/project/melvinlee/sqlcmdtools)

# SQLCmdTools
A little helper to execute .sql file in batch.

# Import Module

    Import-Module .\SqlCmdTools.psm1

# Usage

To execute all .sql in given directory

    Invoke-SqlCmdScript -Path <path> -Server <server> -Database <database>


