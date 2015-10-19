define create_instances(
	$servername, 
	$port, 
	$ipaddress, 
	$instance_type, 
	$image_id ,
	$availability_zone, 
	$subnet, 
	$disksize, 
	$security_group, 
	$glob_region, 
	$glob_subnet_prefix, 
	$glob_image_id, 
	$glob_clustername, 
	$glob_instance_type, 
	$glob_security_group,
	$glob_environment,
	$glob_puppetip ) 
	{
	if !($servername) or !($glob_region) or !($glob_subnet_prefix){
		fail("Missing parameters: servername($servername) region($glob_region) subnet_prefix($glob_subnet_prefix)")
	}
	$ec2_servername = $servername
	$ec2_disksize   = $disksize 
  	$ec2_region     = $glob_region
	if ($image_id){
		$ec2_image_id = $image_id
	}else{
		$ec2_image_id = $glob_image_id
	}
	if $security_group{
		$ec2_security_group = $security_group
	}else{
		$ec2_security_group = $glob_security_group
	}
	if $instance_type {
		$ec2_instance_type = $instance_type
	}else{
		$ec2_instance_type = $glob_instance_type
	}
  	if !is_ip_address($ipaddress) {
		fail("IP $ipaddress is not correct")
	}else{
		$ec2_private_ip_address = $ipaddress
	}
	if $availability_zone{
		$ec2_availability_zone = $availability_zone
	}else{
		case $ec2_private_ip_address {
			/[0-9]{1,3}\.[0-9]{1,3}\.1\.[0-9]{1,3}/: { $ec2_availability_zone = "${glob_region}a"}
			/[0-9]{1,3}\.[0-9]{1,3}\.2\.[0-9]{1,3}/: { $ec2_availability_zone = "${glob_region}b"}
			/[0-9]{1,3}\.[0-9]{1,3}\.3\.[0-9]{1,3}/: { $ec2_availability_zone = "${glob_region}c"}
			/[0-9]{1,3}\.[0-9]{1,3}\.4\.[0-9]{1,3}/: { $ec2_availability_zone = "${glob_region}d"}
			/[0-9]{1,3}\.[0-9]{1,3}\.5\.[0-9]{1,3}/: { $ec2_availability_zone = "${glob_region}e"}
		}
	}
	if $subnet{
		$ec2_subnet = $subnet
	}
	else{
		case $ec2_private_ip_address {
			/[0-9]{1,3}\.[0-9]{1,3}\.1\.[0-9]{1,3}/: { $ec2_subnet = "${glob_subnet_prefix}a"}
			/[0-9]{1,3}\.[0-9]{1,3}\.2\.[0-9]{1,3}/: { $ec2_subnet = "${glob_subnet_prefix}b"}
			/[0-9]{1,3}\.[0-9]{1,3}\.3\.[0-9]{1,3}/: { $ec2_subnet = "${glob_subnet_prefix}c"}
			/[0-9]{1,3}\.[0-9]{1,3}\.4\.[0-9]{1,3}/: { $ec2_subnet = "${glob_subnet_prefix}d"}
			/[0-9]{1,3}\.[0-9]{1,3}\.5\.[0-9]{1,3}/: { $ec2_subnet = "${glob_subnet_prefix}e"}
		}
	}
	notify{"$ec2_region, $ec2_image_id,$ec2_instance_type, $ec2_availability_zone,$ec2_private_ip_address,$ec2_subnet,$ec2_security_group":}
	$ec2_user_data = "#!/bin/bash
/etc/init.d/puppet stop
echo '${servername}' > /etc/hostname
/etc/init.d/hostname.sh start
rm -R /var/lib/puppet/ssl
sed 's/^\s*environment.*/environment = ${glob_environment}/g' -i /etc/puppet/puppet.conf
sed '/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+.*puppet.*/d' -i /etc/puppet/puppet.conf
echo '${glob_puppetip} puppet backup1.coresuite.com' >> /etc/hosts
/etc/init.d/puppet start      

"
	if $ec2_disksize {
		ec2_instance { "${servername}":
  			ensure        => present,
  			region        => $ec2_region,
  			image_id      => $ec2_image_id, # you need to select your own AMI
  			instance_type => $ec2_instance_type,
			availability_zone => $ec2_availability_zone,
			user_data	=> $ec2_user_data,
			private_ip_address => $ec2_private_ip_address,
			subnet => $ec2_subnet,
			security_groups => [ $ec2_security_group,'ssh','monitoring' ],
			block_devices => [
			{
                                device_name  => '/dev/sda1',
                                volume_size  => 30,
                        },
  			{
    				device_name  => '/dev/sdd',
    				volume_size  => $ec2_disksize,
  			}
			]
		}
	}else {
		ec2_instance { "${servername}":
  			ensure        => present,
  			region        => $ec2_region,
  			image_id      => $ec2_image_id, # you need to select your own AMI
  			instance_type => $ec2_instance_type,
			user_data	=> $ec2_user_data,
			availability_zone => $ec2_availability_zone,
			private_ip_address => $ec2_private_ip_address,
			subnet => $ec2_subnet,
			security_groups => [ $ec2_security_group,'ssh','monitoring' ],
		}	
	}
	
}
