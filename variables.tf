#METADATA VARIABLES----------------------
variable "cluster_name" {
  description = "Used to name resources created throughout AWS"
  type        = string
}

variable "tags" {
  description = "Tags applied to all Airflow related objects"
  type        = map
  default = {
    "Project" = "Airflow"
  }

}#AWS VARIABLES------------------
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profile from AWS credential file to be used"
  type        = string
  default     = "default"
}

variable "aws_availability_zones" {
  description = "Avaiability zones resources willl be deployed to. Need at least 3"
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


#RDS DB VARIABLES------------------------------------
variable "db_instance_type" {
  description = "Instance type for PostgreSQL database"
  type        = string
  default     = "db.t2.micro"
}

variable "db_dbname" {
  description = "PostgreSQL database name"
  type        = string
  default     = "airflow"
}

variable "db_username" {
  description = "PostgreSQL database username"
  type        = string
  default     = "airflow"
}

variable "db_password" {
  description = "PostgreSQL database password"
  type        = string
}

variable "fernet_key" {
  description = "Key for encrypting data in the database - see Airflow docs."
  type = string
}