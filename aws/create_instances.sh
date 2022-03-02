
usage() {
    cat <<EOF
bash $1 [--num 1]
EOF
}


num="1"
while [ "$1" != "" ]; do
    case $1 in
        --num )
            shift
            num=$1
        -h | --help ) usage $0
            exit 1
        ;;
        * ) usage $0
            exit 1
    esac
    shift
done

# create t2.medium instances with ubuntu 20.04
aws ec2 run-instances --image-id ami-04505e74c0741db8d --count $num --instance-type t2.medium --key-name $pem

# collect ips
aws ec2 describe-instances  | grep "PublicIpAddress" | awk '{print $2}' | sed 's/[",]//g' 2>&1 | tee ips.txt

# install docker to all the collected ips
bash ../deploy_docker.sh