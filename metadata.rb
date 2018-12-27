# encoding: utf-8
# Copyright (c) 2018 Xcelligen Inc. All rights reserved
name "Windows_2012_MS_STIG"
maintainer 'Xcelligen Inc.'
maintainer_email ""
license 'All Rights Reserved'
description 'Installs/Configures Windows_2012_MS_STIG'
long_description 'Installs/Configures Windows_2012_MS_STIG'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

supports 'windows', '= 2012'