# # encoding: utf-8

# Inspec test for recipe aws_cloudwatch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('amazon-cloudwatch-agent') do
  it { should be_installed }
end