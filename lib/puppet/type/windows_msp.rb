Puppet::Type.newtype(:windows_msp) do
  desc <<-DESC
Install MSP patches using Puppet.  Since we don't know whats inside the MSP
file, user must pass a list of files to check for the requisite version which
we will use to test whether the patch has been applied or not.  It may be
possible to extract this info from the MSP file itself in the future, there's
a cool blog post detailing this process at https://blogs.msdn.microsoft.com/heaths/2006/02/14/extract-files-from-patches/
PR? ;-)

A note on backslashes: Since windows uses the backslash as a path delimiter
and puppet uses it as an escape character, please pass all paths used with
this module delimited using the forward slash `/` and the code will Do The
Right Thing (TM), eg `C:/temp/patches/upgrademe.msp`

@example Testing for patching overriding file version as required
  windows_msp { 'c:/windows/temp/KB4016126-AMD64-Server.msp":
    version => '7.1.10226.1090',
    files => {
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/csdal.dll" => undef,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataAccessService.OperationsManager.dll" => undef,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataWarehouse.DataAccess.dll" => undef,,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.HealthService.Modules.DataWarehouse.dll" => undef,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.RuntimeService.dll" => '7.2.2226.1090',
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.Utility.WorkflowExpansion.dll" => undef,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.Mom.Modules.ClientMonitoring.dll" => undef,
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/NetworkDiscoveryModules.dll" => undef,
    },
  }


@example Testing for patching using a list of files that are all the same version
  windows_msp { 'c:/windows/temp/KB4016126-AMD64-Server.msp":
    version => '7.1.10226.1090',
    files => [
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/csdal.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataAccessService.OperationsManager.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataWarehouse.DataAccess.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.HealthService.Modules.DataWarehouse.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.RuntimeService.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.Utility.WorkflowExpansion.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.Mom.Modules.ClientMonitoring.dll",
      "C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/NetworkDiscoveryModules.dll",
    ],
  }
  DESC


  ensurable do
    desc "Ensure the patch is applied. Removal/rollback not supported"
    defaultvalues
    defaultto(:present)
  end

  newparam(:files) do
    desc "Array of files or Hash of files+versions matching the state of the system after the patch has been applied"
    isrequired
    validate do |value|
      if value.is_a? Hash or value.is_a? Array
        if value.empty?
          fail Puppet::Error, "Msp_file[#{resource[:name]} must list at least one file"
        else
          value.each { |k,v|
            file = k || v
            if ! Puppet::Util.absolute_path?(file)
              fail Puppet::Error, "File #{file} in Msp_file[#{resource[:name]} is not an absolute path"
            end
          }
        end
      else
        fail Puppet::Error "Msp_file[#{resource[:name]} files parameter must be an Array of files or Hash of files+versions"
      end
      unless value.size > 0

      end
    end
  end

  newparam(:version) do
    desc "Version string to test the files listed in `files` for after the patch has been applied"
    isrequired
  end

  newparam(:name) do
    desc "Path to the MSP file to install"
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Path to MSP file must be fully qualified, not '#{value}'"
      end
    end
  end
end