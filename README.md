# awsbuilder

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with awsbuilder](#setup)
    * [What awsbuilder affects](#what-awsbuilder-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with awsbuilder](#beginning-with-awsbuilder)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module builds loadbalancer, application servers installs security groups. 

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup


### Setup Requirements **OPTIONAL**

Require:
Following security groups to be in VPC 
1. security group with tags  name = ssh 
2. security group with tags   name = monitoring ;

Server where is builder running must have IAM role of admin for account(or any account with permissions to manage EC2 and vpc) to witch VPC belongs
 
### Beginning with awsbuilder

Builds flowing security groups:
 ${cluster_name}-appservers - for applications servers
 ${cluster_name}-databases - for database servers NOT RDS ONLY EC
 ${cluster_name}-loadbalancers - for loadbalancer servers

## Examle usage

$dp_app_servers = {
 
        b1adp => {
                servername => 'b1adp.coresuite.com',
                ipaddress => '10.3.1.15',
                port => '8443',
                instance_type => undef,
                security_group => undef,
                image_id => undef,
                availability_zone => undef,
                subnet => undef,
                disksize => undef,
                },
 
        b1bdp => {
                servername => 'b1bdp.coresuite.com',
                ipaddress => '10.3.2.15',
                port => '8443',
                instance_type => undef,
                security_group => undef,
                image_id => undef,
                availability_zone => undef,
                subnet => undef,
                disksize => undef,
                },
}
 
$dp_lb_servers = {
 
        l1adp => {
                servername => 'l1adp.coresuite.com',
                ipaddress => '10.3.1.6',
                port => '8443',
                instance_type => 'm3.medium',
                security_group => undef,
                image_id => undef,
                availability_zone => undef,
                subnet => undef,
                disksize => undef,
                },
 
}
 
$dp_db_servers = {
 
        d1adpmc => {
                servername => 'd1adpmc.coresuite.com',
                ipaddress => '10.3.1.101',
                port => '8443',
                instance_type => 'm3.large',
                security_group => undef,
                image_id => undef,
                availability_zone => undef,
                subnet => undef,
                disksize => undef,
                },
 
}


## Limitations

Is only example how to use puppet aws module - you need to modify it to meet your reqiurements

