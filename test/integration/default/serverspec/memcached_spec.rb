require 'spec_helper'

describe service('memcached') do
  it { should be_enabled }
end
describe service('memcached_test') do
  it { should be_running }
end
