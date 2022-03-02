# ua_tools

creating instances and running some scripts

## Setting up

### AWS

1. create aws account

2. create key-pair (pem file), security group for ssh only with same name.

3. avoid asking for pem on each ssh
```
ssh-agent bash
ssh-add ua_tools.pem
```

4. create some instances
```bash
pushd aws
bash create_instances.sh --num 10
popd
```

## Use instances

```bash
# stop all the dockers if anything is running
bash stop_all.sh
# run flood attack, where sber - file with urls
bash run_ddos.sh --url sber --attack flood --nj 1000
```

## Stop instances

### AWS

```bash
cd aws && bash terminate_instances.sh
```