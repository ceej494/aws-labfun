variable "ami_id" {
  default = "ami-0ba918c33a279f6c0" #ec2-my-configured-mongo
  #default = "ami-02e895cb457bcdbd2" #ec2-my-mongo, needs validation
  #default = "ami-023e152801ee4846a" #AL2023
  #default = "ami-0cf2b4e024cdb6960" #ubuntu
}
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "my-mongoDB-instance"
}
# variable "key_name" {
#   type        = string
#   default     = "my-key-pair"
# }
variable "instance_type" {
  default = "t2.micro"
}
