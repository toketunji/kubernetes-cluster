variable "name" {
  default = "tealorganisation.tk"
}

variable "region" {
  default = "eu-west-1"
}

variable "azs" {
  default = ["eu-west-1a"]
  type    = "list"
}

variable "env" {
  default = "staging"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}
