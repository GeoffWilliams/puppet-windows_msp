require 'spec_helper'
describe 'windows_msp' do
  context 'with default values for all parameters' do
    it { should contain_class('windows_msp') }
  end
end
