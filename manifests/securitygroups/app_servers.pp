define awsbuilder::securitygroups::app_servers($glob_region,$glob_clustername,$glob_vpc )
{

	ec2_securitygroup {$title:
		ensure      => present,
  		region      => $glob_region,
		vpc	    => $glob_vpc,
		tags	    => {
			'Name' => $title
		},
  		description => "Security group for cluster ${glob_cluster_name} app servers",
  		ingress     => [{
    			protocol  => 'tcp',
    			port      => 8443,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 9443,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 5445,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 5455,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 22,
    			cidr      => '0.0.0.0/0',
  		}]
  	}

}
