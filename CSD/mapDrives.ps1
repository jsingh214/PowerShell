#Drive maps, will need to get a share setup for drive D on file server

New-PSDrive –Name “H” –PSProvider FileSystem –Root “\\CSD160\D$” –Persist

New-PSDrive –Name “S” –PSProvider FileSystem –Root “\\CSD160\CSDshared” –Persist

New-PSDrive –Name “U” –PSProvider FileSystem –Root “\\CSD160\ITAdmins” –Persist