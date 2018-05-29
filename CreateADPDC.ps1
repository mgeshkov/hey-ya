configuration CreateADPDC 
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$DomainName,
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds
    ) 
    
    Import-DscResource -ModuleName xActiveDirectory, xStorage, xNetworking, PSDesiredStateConfiguration, xPendingReboot, xExchange
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $Interface=Get-NetAdapter|Where Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias=$($Interface.Name)
    $extractExBin = "C:\Install\Exchange2013-x64-cu20"

    Node localhost
    {
        LocalConfigurationManager 
        {
            RebootNodeIfNeeded = $true
        }

	    WindowsFeature DNS 
        { 
            Ensure = "Present" 
            Name = "DNS"		
        }

        Script EnableDNSDiags
	    {
      	    SetScript = { 
		        Set-DnsServerDiagnostics -All $true
                Write-Verbose -Verbose "Enabling DNS client diagnostics" 
            }
            GetScript =  { @{} }
            TestScript = { $false }
	        DependsOn = "[WindowsFeature]DNS"
        }

	    WindowsFeature DnsTools
	    {
	        Ensure = "Present"
            Name = "RSAT-DNS-Server"
            DependsOn = "[WindowsFeature]DNS"
	    }

        xDnsServerAddress DnsServerAddress 
        { 
            Address        = '127.0.0.1' 
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = 'IPv4'
	        DependsOn = "[WindowsFeature]DNS"
        }

        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"
	        DependsOn="[WindowsFeature]DNS" 
        } 

        WindowsFeature ADDSTools
        {
            Ensure = "Present"
            Name = "RSAT-ADDS-Tools"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        WindowsFeature ADAdminCenter
        {
            Ensure = "Present"
            Name = "RSAT-AD-AdminCenter"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature ASHTTPActivation
        {
            Ensure = "Present"
            Name = "AS-HTTP-Activation"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
         
            WindowsFeature DesktopExperience
        {
            Ensure = "Present"
            Name = "Desktop-Experience"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature NETFrameworkFeatures
        {
            Ensure = "Present"
            Name = "NET-Framework-45-Features"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature RPCoverHTTPproxy
        {
            Ensure = "Present"
            Name = "RPC-over-HTTP-proxy"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature RSATClustering
        {
            Ensure = "Present"
            Name = "RSAT-Clustering"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature RSATClusteringCmdInterface
        {
            Ensure = "Present"
            Name = "RSAT-Clustering-CmdInterface"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature RSATClusteringMgmt
        {
            Ensure = "Present"
            Name = "RSAT-Clustering-Mgmt"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature RSATClusteringPowerShell
        {
            Ensure = "Present"
            Name = "RSAT-Clustering-PowerShell"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature WebMgmtConsole
        {
            Ensure = "Present"
            Name = "Web-Mgmt-Console"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature WASProcessModel
        {
            Ensure = "Present"
            Name = "WAS-Process-Model"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature WebAspNet45
        {
            Ensure = "Present"
            Name = "Web-Asp-Net45"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature WebBasicAuth
        {
            Ensure = "Present"
            Name = "Web-Basic-Auth"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

            WindowsFeature WebClientAuth
        {
            Ensure = "Present"
            Name = "Web-Client-Auth"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
            WindowsFeature WebDigestAuth
        {
            Ensure = 'Present'
            Name = 'Web-Digest-Auth'
        }
          WindowsFeature WDB
        {
            Ensure = 'Present'
            Name = 'Web-Dir-Browsing'
        }
           WindowsFeature WDC
        {
            Ensure = 'Present'
            Name = 'Web-Dyn-Compression'
        }
           WindowsFeature WebHttp
        {
            Ensure = 'Present'
            Name = 'Web-Http-Errors'
        }
           WindowsFeature WebHttpLog
        {
            Ensure = 'Present'
            Name = 'Web-Http-Logging'
        }
           WindowsFeature WebHttpRed
        {
            Ensure = 'Present'
            Name = 'Web-Http-Redirect'
        }
          WindowsFeature WebHttpTrac
        {
            Ensure = 'Present'
            Name = 'Web-Http-Tracing'
        }
          WindowsFeature WebISAPI
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Ext'
        }
          WindowsFeature WebISAPIFilt
        {
            Ensure = 'Present'
            Name = 'Web-ISAPI-Filter'
        }
            WindowsFeature WebLgcyMgmt
        {
            Ensure = 'Present'
            Name = 'Web-Lgcy-Mgmt-Console'
        }
            WindowsFeature WebMetaDB
        {
            Ensure = 'Present'
            Name = 'Web-Metabase'
        }
            WindowsFeature WebMgmtSvc
        {
            Ensure = 'Present'
            Name = 'Web-Mgmt-Service'
        }
           WindowsFeature WebNet45
        {
            Ensure = 'Present'
            Name = 'Web-Net-Ext45'
        }
            WindowsFeature WebReq
        {
            Ensure = 'Present'
            Name = 'Web-Request-Monitor'
        }
             WindowsFeature WebSrv
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
              WindowsFeature WebStat
        {
            Ensure = 'Present'
            Name = 'Web-Stat-Compression'
        }
               WindowsFeature WebStatCont
        {
            Ensure = 'Present'
            Name = 'Web-Static-Content'
        }
               WindowsFeature WebWindAuth
        {
            Ensure = 'Present'
            Name = 'Web-Windows-Auth'
        }
              WindowsFeature WebWMI
        {
            Ensure = 'Present'
            Name = 'Web-WMI'
        }
              WindowsFeature WebIF
        {
            Ensure = 'Present'
            Name = 'Windows-Identity-Foundation'
        }

        xADDomain FirstDS 
        {
            DomainName = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = "C:\NTDS"
            LogPath = "C:\NTDS"
            SysvolPath = "C:\SYSVOL"
	        DependsOn = @("[WindowsFeature]ADDSInstall")
        }
        Script InstalldotNet
        {
           
            SetScript = {
                $installDir = "C:\Install"
                #If C:\Install directory does not exist creat it
                if (!(Test-path $installDir))
                {
                mkdir $installDir
                }
                #Variables
                $dotNet462Url = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
                $dotNet462File = "C:\Install\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
                #If .Net 4.6.2 file is not present in C:\Install, download and silently install it.
                if (!(Test-path $dotNet462File))
                    {
                        $webclient1 = New-Object System.Net.WebClient
                        $webclient1.DownloadFile($dotNet462Url, $dotNet462File)
                        Start-sleep 120
                        Start-Process -FilePath $dotNet462File -ArgumentList "-q"
                        Start-sleep 120
                    }
            }
            TestScript = { 
                Test-Path "C:\Install\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
            }
            GetScript =  { @{} }
        }
        Script InstallUCMA
        {
           
            SetScript = {
                $installDir = "C:\Install"
                #If C:\Install directory does not exist creat it
                if (!(Test-path $installDir))
                {
                mkdir $installDir
                }
                #Variables
                $unifComManaged40Url = "https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe"
                $unifComManaged40File = "C:\Install\UcmaRuntimeSetup.exe"
                #If UCMA file is not present in C:\Install, download and silently install it.
                if (!(Test-path $unifComManaged40File))
                    {
                        $webclient2 = New-Object System.Net.WebClient
                        $webclient2.DownloadFile($unifComManaged40Url, $unifComManaged40File)
                        Start-sleep 120
                        Start-Process -FilePath $unifComManaged40File -ArgumentList "-q"
                        Start-sleep 120
                    }
            }
            TestScript = { 
                Test-Path "C:\Install\UcmaRuntimeSetup.exe"
            }
            GetScript =  { @{} }
        }
        Script InstallExchangePrereq
        {
           
            SetScript = {
                $installDir = "C:\Install"
                #If C:\Install directory does not exist creat it
                if (!(Test-path $installDir))
                {
                mkdir $installDir
                }
                #Variables
                $Exchange2013CU20DLUrl="https://download.microsoft.com/download/3/9/B/39B25E37-2265-4FBC-AF87-7CA6CA089615/Exchange2013-x64-cu20.exe"
                $tempfile = "C:\Install\Exchange2013-x64-cu20.exe"
                $extractDir = "C:\Install\Exchange2013-x64-cu20"
                #If Exchange setup file does not exist download it
                if (!(Test-path $tempfile))
                    {
                    $webclient = New-Object System.Net.WebClient
                    $webclient.DownloadFile($Exchange2013CU20DLUrl, $tempfile)
                    }
                #If Exchange setup file is not de-archived do it
                if (!(Test-path $extractDir))
                {
                    Start-Process -FilePath "C:\Install\Exchange2013-x64-cu20.exe" -ArgumentList "/extract:C:\Install\Exchange2013-x64-cu20 /quiet"
                    do {
                        Write-Host "Sleeping for 2 min"
                        Start-Sleep 120
    
                    } while (Get-Process | where {$_.ProcessName -eq "Exchange2013-x64-cu20"})
                }
            }
            TestScript = { 
                Test-Path "C:\Install"
            }
            GetScript =  { @{} }
            
        }
        xPendingReboot BeforeExchangeInstall
        {
            Name      = "BeforeExchangeInstall"
        }
        xExchInstall InstallExchange
        {
            Path       = $extractExBin + "\Setup.exe"
            Arguments  = "/mode:Install /role:ClientAccess,Mailbox /OrganizationName:MyExchangeOrg /IAcceptExchangeServerLicenseTerms"
            Credential = $DomainCreds
            DependsOn = "[xADDomain]FirstDS","[Script]InstallExchangePrereq"
        }
        xPendingReboot AfterExchangeInstall
        {
            Name      = "AfterExchangeInstall"

            DependsOn = '[xExchInstall]InstallExchange'
        }

   }
} 