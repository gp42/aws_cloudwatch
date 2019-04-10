name 'aws_cloudwatch'
maintainer 'Gennady Potapov'
license 'Apache-2.0'
description 'Provides aws_cloudwatch_agent resource'
version '1.0.2'
chef_version '>= 12.14' if respond_to?(:chef_version)

supports 'ubuntu', '= 14.04'
supports 'ubuntu', '= 16.04'
supports 'centos'
supports 'fedora'
supports 'amazon'

issues_url 'https://github.com/gp42/aws_cloudwatch/issues'
source_url 'https://github.com/gp42/aws_cloudwatch'
