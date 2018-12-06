#
# Cookbook:: aws_cloudwatch
# Attributes:: default
#
# Copyright:: 2018, Gennady Potapov, All Rights Reserved.

# Links: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-first-instance.html#download-CloudWatch-Agent-on-EC2-Instance-first
default['aws_cloudwatch']['installers'] = {
  'amazon': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm.sig'
  },
  'centos': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm.sig'
  },
  'redhat': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm.sig'
  },
  'fedora': {
      'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm',
      'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm.sig'
  },
  'suse': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/suse/amd64/latest/amazon-cloudwatch-agent.rpm',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/suse/amd64/latest/amazon-cloudwatch-agent.rpm.sig'
  },
  'debian': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb.sig'
  },
  'ubuntu': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb.sig'
  },
  'windows': {
    'package': 'https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip',
    'sig': 'https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip.sig'
  }
}
default['aws_cloudwatch']['gpg']['public_key'] = 'https://s3.amazonaws.com/amazoncloudwatch-agent/assets/amazon-cloudwatch-agent.gpg'
default['aws_cloudwatch']['gpg']['fingerprint'] = '937616F3450B7D806CBD9725D58167303B789C72'
default['aws_cloudwatch']['config']['path'] = {
  "linux": '/opt/aws/amazon-cloudwatch-agent/etc',
  "windows": 'C:\ProgramData\Amazon\AmazonCloudWatchAgent'
}
default['aws_cloudwatch']['config']['file_name'] = 'common-config.toml'
default['aws_cloudwatch']['config']['json_file_name'] = 'amazon-cloudwatch-agent.json'
default['aws_cloudwatch']['config']['params'] = {
  :shared_credential_profile => nil,
  :shared_credential_file => nil,
  :http_proxy => nil,
  :https_proxy => nil,
  :no_proxy => nil
}
default['aws_cloudwatch']['dependencies'] = {
    'redhat': ['gnupg'],
    'fedora': ['gnupg']
}