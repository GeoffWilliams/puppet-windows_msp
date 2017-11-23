require "fileutils"
require "digest/md5"
Puppet::Type.type(:windows_msp).provide(:ruby) do
  desc "SCP support"


  commands  :msiexec => "msiexec"

  def check_version(file, version)

    file = file.tr('/', '\\')

    ps = "if ((Get-Item \"#{file}\").VersionInfo.FileVersion -eq \"#{version}\"){ exit 0 } else { exit 1 }"
    Puppet::Util::Execution.execute(['powershell.exe', ps]).exitstatus.zero?
  end

  def exists?
    state = true
    @resource[:files].each { |k,v|
      # If v is nil, an array is being iterated and the value is k.
      # If v is not nil, a hash is being iterated and the value is v.
      # https://stackoverflow.com/a/16413593/3441106
      version =
        if v.instance_of? String
          v
        else
          @resource[:version]
        end
      file = k || v

      file_state = check_version(file, version)
      if ! file_state
        Puppet.debug "#{resource[:name]} still needs to patch #{file}"
      end
      state &= file_state
    }

    Puppet.debug "#{resource[:name]} already applied: #{state}"

    state
  end

  def create
    Puppet.info("Installing MSP file #{resource[:name]}")
    msp_file = resource[:name].tr('/', '\\')
    msiexec('/update', msp_file, '/quiet')
  end

  def destroy
    # un-apply a patch is not supported yet and probably never will be
    # example of how to uninstall here if anyone wants to add it in the future
    # https://www.msigeek.com/647/command-line-switches-for-msi-and-msp-installations
    #
    # Uninstalling patches with puppet sounds like overkill though- why not just
    # not install it in the first place ;-) If you goofed and need to rollback
    # quickly, suggest an orchestration or re-imaging approach
    Puppet.error("uninstall/rollback MSP not supported!")
  end

end