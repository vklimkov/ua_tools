
user="ubuntu"
ips_path="ips.txt"
if [ ! -f "$ips_path" ]; then
  ips_path="aws/ips.txt"
fi
if [ ! -f "$ips_path" ]; then
  echo "cant find ips.txt"
  exit 1
fi

ips="$(cat $ips_path | tr '\n' ',')"
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ansible-playbook -i ${ips} -u $user -b ${script_dir}/ansible_play.yaml