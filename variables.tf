variable "sshkey" {
    description = "Public SSH Key for remote sessions"
}

variable "image" {
    description = "Consul image for Azure deployment"
}

variable "nomadimage" {
    description = "Nomad Image for Azure deployment"
}

variable "nomadclientimage" {
    description = "Nomad Client Image for Azure deployment"
}