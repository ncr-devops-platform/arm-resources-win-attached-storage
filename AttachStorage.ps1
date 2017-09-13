Configuration AttachedDisk
{
  Import-DscResource -ModuleName xStorage

  Node "localhost"
  {
    Script EnableUnrestrictedExecutionPolicy
    {
      SetScript = { Set-ExecutionPolicy -ExecutionPolicy unrestricted -force }
      GetScript =  { Get-ExecutionPolicy }
      TestScript = { (Get-ExecutionPolicy) -eq "Unrestricted" }
    }

    xWaitforDisk Disk2
    {
      DiskId = 2
      RetryIntervalSec = 20
      RetryCount = 30
      DependsOn = "[Script]EnableUnrestrictedExecutionPolicy"
    }
    
    xDisk ADDataDisk {
      DiskId = 2
      DriveLetter = "F"
      DependsOn = @("[xWaitForDisk]Disk2", "[Script]EnableUnrestrictedExecutionPolicy")
    }

    Script EnableRestrictedExecutionPolicy
    {
      SetScript = { Set-ExecutionPolicy -ExecutionPolicy Restricted -force }
      GetScript =  { Get-ExecutionPolicy }
      TestScript = { (Get-ExecutionPolicy) -eq "Restricted" }
      DependsOn "[xDisk]ADDataDisk"
    }
  }
}