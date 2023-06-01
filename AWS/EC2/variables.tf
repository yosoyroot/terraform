variable "image" {
  default     = "ami-0cad4fd0aee82f4c3"
  description = "Default Image to be Used"
}

variable "instance-type" {
  default     = "t2.micro"
  description = "Default Instance type to be Used"
}

variable "number" {
  default     = 4
  description = "Default count number to be Used"
}

variable "servername" {
  default     = "webserver"
  description = "Default server name prefix to be Used"
}

variable "servertag" {
  default     = "Nginx"
  description = "Default server tag to be Used"
}
