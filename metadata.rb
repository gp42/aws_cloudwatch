name 'aws_cloudwatch'
maintainer 'Gennady Potapov'
license 'Apache-2.0'
description 'Provides aws_cloudwatch_agent resource'
version '2.0.0'
chef_version '>= 13.0' if respond_to?(:chef_version)

supports 'ubuntu', '= 16.04'
supports 'ubuntu', '= 18.04'
supports 'ubuntu', '= 20.04'
supports 'debian', '>= 9'
supports 'centos', '= 7'
supports 'fedora'
supports 'amazon'

issues_url 'https://github.com/gp42/aws_cloudwatch/issues'
source_url 'https://github.com/gp42/aws_cloudwatch'
