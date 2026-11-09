aws ec2 describe-instances \
  --region "$AWS_REGION" \
  --query 'Reservations[].Instances[].{
    InstanceId:InstanceId,
    Name:Tags[?Key==`Name`]|[0].Value,
    State:State.Name,
    OS:PlatformDetails,
    AMI:ImageId,
    LaunchTime:LaunchTime
  }' \
  --output json \
  > hitrust-evidence/ec2/inventory.json

aws ssm describe-instance-information \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/managed-instances.json

aws ssm-quicksetup list-configuration-managers \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/quicksetup.json

aws ssm-quicksetup get-configuration-manager \
  --manager-arn "ARN_DEL_CONFIGURATION_MANAGER" \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/quicksetup-details.json

aws ssm describe-patch-baselines \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/patch-baselines.json

aws ssm describe-patch-groups \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/patch-groups.json

aws ssm describe-maintenance-windows \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/maintenance-windows.json


for ID in $(aws ssm describe-maintenance-windows \
  --region "$AWS_REGION" \
  --query 'WindowIdentities[].WindowId' \
  --output text); do

  aws ssm describe-maintenance-window-targets \
    --window-id "$ID" \
    --region "$AWS_REGION" \
    > "hitrust-evidence/ssm/${ID}-targets.json"

  aws ssm describe-maintenance-window-tasks \
    --window-id "$ID" \
    --region "$AWS_REGION" \
    > "hitrust-evidence/ssm/${ID}-tasks.json"

  aws ssm describe-maintenance-window-executions \
    --window-id "$ID" \
    --region "$AWS_REGION" \
    > "hitrust-evidence/ssm/${ID}-executions.json"

done


aws ssm list-associations \
  --region "$AWS_REGION" \
  --output json \
  > hitrust-evidence/ssm/associations.json




  
