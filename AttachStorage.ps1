Configuration AttachedDisk
{
  Set-ExecutionPolicy -ExecutionPolicy unrestricted -force
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  Import-DscResource -ModuleName xStorage

  Node "localhost"
  {
    xWaitforDisk Disk2
    {
      DiskId = 2
      RetryIntervalSec = 20
      RetryCount = 30
    }
    
    xDisk ADDataDisk {
      DiskId = 2
      DriveLetter = "F"
      DependsOn = "[xWaitForDisk]Disk2"
    }

    Script EnableRestrictedExecutionPolicy
    {
      SetScript = { Set-ExecutionPolicy -ExecutionPolicy Restricted -force }
      GetScript =  { Get-ExecutionPolicy }
      TestScript = { (Get-ExecutionPolicy) -eq "Restricted" }
      DependsOn = "[xDisk]ADDataDisk"
    }
  }
}