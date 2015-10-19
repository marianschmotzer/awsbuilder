define awsbuilder::securitygroups::db_servers($glob_region,$glob_clustername,$glob_vpc )
{

	ec2_securitygroup {"${title}":
		ensure      => present,
  		region      => $glob_region,
		vpc	    => $glob_vpc,
		tags        => {
                        'Name' => $title
                },
  		description => "Security group for cluster ${glob_cluster_name} database servers",
  		ingress     => [{
    			protocol  => 'tcp',
    			port      => 5432,
    			cidr      => '0.0.0.0/0',
  		},
  		{
    			protocol  => 'tcp',
    			port      => 5433,
    			cidr      => '0.0.0.0/0',
  		},
  		]
  	}

}
