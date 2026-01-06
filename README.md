# aws-webserver-elb
basic terraform for an aws webserver, vms, and all network necessary

## contents of this repo
terraform code for provisioning resources on aws
the resources are
- vpc 
- 2x subnets
- 1x elb
- 3x ec2 vms
- 2x s3 bucket, one for state, other for general data
- ssm for ssh keys 
- sg (firewall rules)

## content
no content related to a website yet
maybe my 'hugo' template website
maybe a generic hello world
maybe a portfolio

## CI/CD
the machine can copy stuff from a S3, or receive directly from a github actions, gitlab ci runner... ? 
