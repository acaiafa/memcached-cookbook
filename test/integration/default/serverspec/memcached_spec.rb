require 'spec_helper'

describe service('memcached') do
  it { should be_enabled }
  it { should be_running }
end
