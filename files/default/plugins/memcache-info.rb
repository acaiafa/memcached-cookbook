#memcached ips
provides "memcached"
memcached Mash.new
##get info
get_int_info = %x{ip addr |grep -i 'eth0:' |awk '{print $2, $8}'|sed 's/\\/16//' |sed 's/eth0://g'}
##split_data
split_int_info = get_int_info.split().reverse
##create hash
int_info = Hash[*split_int_info]

    int_info.each do |int,ip|
        memcached[:instance_name_here] = ip if int.include?("instance_name_here")
        memcached[:instance_name_here] = ip if int.include?("instance_name_here")
        memcached[:instance_name_here] = ip if int.include?("instance_name_here")
    end
