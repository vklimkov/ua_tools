

ips_path="ips.txt"
if [ ! -f "$ips_path" ]; then
  ips_path="aws/ips.txt"
fi
if [ ! -f "$ips_path" ]; then
  echo "cant find ips.txt"
  exit 1
fi

for ip in $(cat $ips_path); do
  ssh ubuntu@${ip} bash clean_docker.sh
done
