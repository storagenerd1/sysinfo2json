#/bin/bash
# System information Collect Script with json output format
# 09012017 Storagenerd v0.1 First version

DATE=`/bin/date +date_%d-%m-%y_time_%H-%M-%S`

Hostname(){
echo "    \"hostname\": \"`hostname -f`\","
}
GenInfo(){
echo "    \"systeminfo\": {"
echo "        \"architecture\": \"`arch`\","
echo "        \"kernel\": \"`uname -r`\","
echo "        \"ostype\": \"`head -n1 /etc/issue`\","
echo "        \"timezone\": `awk -F'=' '/^ZONE/ { print $2 }' /etc/sysconfig/clock`,"
echo "        \"datetime\": \"`date`\","
echo "        \"uptime\": \"`uptime | awk '{ gsub(/,/, ""); print $3 }'`\""
echo "    },"
}

CPUInfo(){ 
echo "    \"cpuinfo\": {"
echo "        \"cputype\": \"`lscpu|grep "Model name"|awk '{print $3,$4,$5,$6,$7,$8}'`\","
echo "        \"sockets\": \"`lscpu|grep "Socket"|awk '{print $2}'`\","
echo "        \"cores\": \"`lscpu|grep "Core(s)"|awk '{print $4}'`\","
echo "        \"speed\": \"`lscpu|grep "CPU MHz"|awk '{print $3}'`\","
echo "        \"cache\": \"`lscpu|grep "L3"|awk '{print $3}'`\""
echo "    },"
}

MemInfo(){
echo "    \"meminfo\": {"
echo "        \"ram\": \"`free -m | grep Mem | awk '{print $2}'` GB\","
echo "        \"swap\": \"`free -m | grep Swap | awk '{print $2}'` GB\""
echo "    },"
}

FileSInfo(){
echo "    \"filesystem\": {"
echo "        \" \","
echo "    },"
}

PCIInfo(){
echo "    \"pciinfo\": {"
echo "        \" \","
echo "    },"
}

NetInfo(){
echo "    \"network\": {"
for net in `ip -f inet -o addr|awk '{print $2}'`
do
    echo "        \"$net\": \"`ip -f inet -o addr show $net|awk '{print $4}'`\","
done
echo "        \"bogus\": \"bogus\""
echo "    },"
}

PkgInfo(){
echo "    \"packages\": {"
for pkg in `rpm -qa --queryformat "%{NAME}\n"`
do
    echo "        \"$pkg\": \"`rpm -q $pkg --queryformat "%{VERSION}\n"`\","
done
echo "        \"bogus\": \"bogus\""
echo "    }"
}

## --------------------------------------<script ending>-----------------------------------------##

Run(){
echo "{\"sysinfo\": {"
Hostname
GenInfo
CPUInfo
MemInfo
#FileSInfo
#PCIInfo
NetInfo
#PkgInfo
echo "}}"
}
log=`hostname -f`_$DATE
Run | tee $log.json
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Temporary
rm -f $log.json
