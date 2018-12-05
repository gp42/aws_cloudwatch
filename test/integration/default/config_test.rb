# # encoding: utf-8

# Inspec test for recipe aws_cloudwatch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

os.windows? ? \
  config_path = 'C:\ProgramData\Amazon\AmazonCloudWatchAgent' : \
  config_path = '/opt/aws/amazon-cloudwatch-agent/etc'

describe file(File::join("#{config_path}", 'common-config.toml')) do
  it { should exist }
  its('content') { should match %r{.*http_proxy = "http://192.168.0.1".*} }
  its('content') { should match %r{.*https_proxy = "https://192.168.0.1".*} }
  its('content') { should match %r{.*no_proxy = "http://192.168.0.10".*} }
  its('content') { should match %r{.*shared_credential_profile = "test_profile".*} }
  its('content') { should match %r{.*shared_credential_file= "/etc/test_credential_file".*} }
end

describe file(File::join("#{config_path}", 'amazon-cloudwatch-agent.json')) do
  it { should exist }
end