Configuration AttachedDisk
{
  Import-DscResource -ModuleName xStorage

  Node "localhost"
  {
    xWaitforDisk Disk2
    {
      DiskNumber = 2
      RetryIntervalSec = 20
      RetryCount = 30
    }
    
    xDisk ADDataDisk {
      DiskNumber = 2
      DriveLetter = "F"
      DependsOn = "[xWaitForDisk]Disk2"
    }
  }
}