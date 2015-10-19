require 'spec_helper'
describe 'awsbuilder' do

  context 'with defaults for all parameters' do
    it { should contain_class('awsbuilder') }
  end
end
