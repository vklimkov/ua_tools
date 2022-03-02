
val=$(aws ec2 describe-instances  | grep "InstanceId" | awk '{print $2}' | sed 's/[",]//g' | tr '\n' ' ' )
aws ec2 terminate-instances --instance-ids $val