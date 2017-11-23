windows_msp { 'z:/host/msps/KB4016126-AMD64-Server.msp':
  ensure  => present,
  version => '7.2.11719.0',
  files   => {
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/csdal.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataAccessService.OperationsManager.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.DataWarehouse.DataAccess.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.HealthService.Modules.DataWarehouse.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.RuntimeService.dll' => '7.2.11878.0',
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.EnterpriseManagement.Utility.WorkflowExpansion.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/Microsoft.Mom.Modules.ClientMonitoring.dll' => undef,
    'C:/Program Files/Microsoft System Center 2016/Operations Manager/Server/NetworkDiscoveryModules.dll' => undef,
  },
}