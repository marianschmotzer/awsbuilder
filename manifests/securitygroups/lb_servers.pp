define awsbuilder::securitygroups::lb_servers($glob_region,$glob_clustername,$glob_vpc )
{

	ec2_securitygroup {"${title}":
		ensure      => present,
  		region      => $glob_region,
		vpc	    => $glob_vpc,
		tags        => {
                        name => $title
                },
  		description => "Security group for cluster ${glob_cluster_name} loadbalancer servers",
  		ingress     => [{
    			protocol  => 'tcp',
    			port      => 443,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 5455,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 5445,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'udp',
    			port      => 123,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 123,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 8888,
    			cidr      => '0.0.0.0/0',
  		}]
  	}

}
