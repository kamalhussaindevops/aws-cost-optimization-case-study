variable "region" {
  type    = string
  default = "us-east-1"
}
variable "project" {
  type    = string
  default = "costcase"
}
variable "db_password" {
  type      = string
  default   = "ChangeMe_throwaway_123!"
  sensitive = true
}
