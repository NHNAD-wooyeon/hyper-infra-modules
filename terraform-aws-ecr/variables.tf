variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "image_scanning_configuration" {
  description = "Configuration block for image scanning"
  type = object({
    scan_on_push = bool
  })
  default = {
    scan_on_push = true
  }
}

variable "encryption_configuration" {
  description = "Configuration block for encryption"
  type = object({
    encryption_type = string
    kms_key        = optional(string)
  })
  default = null
}

variable "lifecycle_policy" {
  description = "The lifecycle policy document for the repository"
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "The repository policy document for the repository"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}