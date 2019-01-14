You are given following details:

- Network CIDR for VPC as variable `network_base_cidr`
- Desired size of a subnet as variable `subnet_size`
- Domain name as variable `apex_domain`
- Maximum size of autoscaling fleet as variable `asg_max_size`
- Minimum size of autoscaling fleet as variable `asg_min_size`
- Desired size of autoscaling fleet as variable `asg_desired_size`
- AMI ID as variable `ami_id`
- Application port as variable `target_group_port`

Please write a Terraform configuration to create following infrastructure:

 - VPC in active region
 - One subnet in each availability zone of active region
 - One internet gateway
 - One NAT gateway in any subnet
 - Route table entries to route traffic from private subnets to internet gateway via the NAT gateway. e.g.
     - Private subnet -> NAT gateway -> Internet gateway
 - One autoscaling group along with a launch configuration.
 	 - ASG must utilize configurable number of on-demand and spot allocations
 - Application load balancer to manage traffic for instances launched by ASG
 	- ALB must redirect all requests from HTTP to HTTPS on LB tier
 	- All HTTPS requests must be served with an SSL certificate mnaged by AWS and issued by AWS certificate manager
 - DNS entry in Route53 to point "terraform-test.${var.apex_domain}" to application load balancer
 	- The DNS record must be an ALIAS type


The configuration must be capable of switching from one region to another simply by adjusting the `region` attribute on provider configuration.
Terraform runtime will not have access to AWS access keys, however it can assume `arn:aws:iam::1234567890:role/TerraformRuntimeRole` role.
