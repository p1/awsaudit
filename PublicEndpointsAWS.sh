Accounts=("default" "account1" "account2")
Regions=("us-east-1" "us-west-1" "us-west-2" "ap-east-1" "ap-southeast-1" "eu-central-1" "eu-west-1" "eu-west-2" "eu-south-2")
for strA in ${Accounts[@]}; do
  echo $strA >> enpointlog.txt
    for strR in ${Regions[@]}; do
      echo $strR
      aws ec2 describe-instances --query=Reservations[].Instances[].PublicIpAddress --region $strR --profile $strA --output text | tr '\t' '\n' | sort | uniq >> endpointlog.txt
      aws ec2 describe-addresses --query Addresses[*].PublicIp --region $strR --profile $strA --output text | tr '\t' '\n' | sort | uniq >> endpointlog.txt
      echo elbs
      aws elbv2 describe-load-balancers --query LoadBalancers[*].DNSName --region $strR --profile $strA --output text | tr '\t' '\n' | sort | uniq >> endpointlog.txt
      echo rds
      aws rds describe-db-instances --query=DBInstances[*].Endpoint.Address --region $strR --profile $strA --output text | tr '\t' '\n' | sort | uniq >> endpointlog.txt
      echo id.execute-api.$strR.amazonaws.com
      aws apigateway get-rest-apis --query items[].id[] --region $strR --profile $strA --output text | tr '\t' '\n' | sort | awk '{print $1".execute-api.$strR.amazonaws.com"}' >> endpointlog.txt
      echo elasticbeanstalk
      aws elasticbeanstalk describe-environments --query Environments[*].EndpointURL --region $strR --profile $strA --output text | tr '\t' '\n' | sort | uniq >> endpointlog.txt
    done
done
