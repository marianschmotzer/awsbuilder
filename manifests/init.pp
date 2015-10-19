# == Class: awsbuilder
#
# Full description of class awsbuilder here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#	$= {
#                b3_1aetadmin => { servername => 'b3aetadmin8443.dev.coresuite.com', 
#				   ipaddress => '10.10.1.13', 
#				   port => '8443',
#				   instance_type => 'm3.large', 
#				   subnet => 'vpc-dev-coresuite-com-zone-a'  
#				   image_id      => undef, # you need to select your own AMI
#				   availability_zone => undef,
#				   disk_size => 30,
#				   subnet => 'vpc-dev-coresuite-com-zone-b',
#				   security_groups => [ "default_app" ],
#				},
#        }
#
# === Authorsvpc-dev-coresuite-com-zone-a
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
# ami-dc55a4ab
class awsbuilder ($region = undef,
		  $instance_type = 'm3.large',
		  $image_id = undef,
		  $cluster_name = undef,
		  $vpc = undef,
		  $subnet_prefix = undef,
		  $lb_servers = undef,
		  $app_servers = undef,
		  $db_servers = undef,
		  $environment = undef,
		  $puppetip = '10.0.1.253',
	) {
	
	package {['aws-sdk-core','retries']:
		ensure => latest,
		provider => 'gem',
	}
	
	if !($region) or !($instance_type) or !($image_id) or !($cluster_name) or !($vpc) or !($subnet_prefix) or !($environment)  {
		fail("Missing parameters - region($region) image_id($image_id) cluster_name($cluster_name) vpc($vpc) subnet_prefix($subnet_prefix) environment($environment)")
	}
	if $app_servers {
		awsbuilder::securitygroups::app_servers {"${cluster_name}-appservers":
			glob_region => $region, 
			glob_clustername => $clustername,
			glob_vpc => $vpc,
		}
		$app_glob = {
			glob_region => $region, 
			glob_subnet_prefix => $subnet_prefix, 
			glob_image_id => $image_id, 
			glob_clustername  => $clustername,
			glob_instance_type => $instance_type,
			glob_security_group => "${cluster_name}-appservers",
			glob_environment => $environment,
			glob_puppetip => $puppetip,
		}	
        	create_resources(create_instances, $app_servers, $app_glob )
	}
	if $db_servers {
		awsbuilder::securitygroups::db_servers {"${cluster_name}-databases":
			glob_region => $region, 
			glob_clustername => $clustername,
			glob_vpc => $vpc,

		} 
		$db_glob = {
			glob_region => $region, 
			glob_subnet_prefix => $subnet_prefix, 
			glob_image_id => $image_id, 
			glob_clustername  => $clustername,
			glob_instance_type => $instance_type,
			glob_security_group => "${cluster_name}-databases",
			glob_environment => $environment,
			glob_puppetip => $puppetip,
		}	
        	create_resources(create_instances, $db_servers, $db_glob )
	}
	if $lb_servers {
		awsbuilder::securitygroups::lb_servers {"${cluster_name}-loadbalancers":
			glob_region => $region, 
			glob_clustername => $clustername,
			glob_vpc => $vpc,
		} 
		$lb_glob = {
			glob_region => $region, 
			glob_subnet_prefix => $subnet_prefix, 
			glob_image_id => $image_id, 
			glob_clustername  => $clustername,
			glob_instance_type => $instance_type,
			glob_security_group => "${cluster_name}-loadbalancers",
			glob_environment => $environment,
			glob_puppetip => $puppetip,
		}	
        	create_resources(create_instances, $lb_servers, $lb_glob )
	}
	

}
