variable "cidr" {
  default = "10.0.0.0/16"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  default     = "toluxfash"
}

variable "db_name" {
  default = "drupal_db"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "securepassword123"
}