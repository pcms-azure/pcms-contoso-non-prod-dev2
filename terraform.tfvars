project          = "pcms-contoso-non-prod"
environment_name = "dev2"
loc              = "westeurope"

address_prefix   = "10.0.0.128/25" // not sure how many VMs per env, so manual for the moment

tags = {
    project     = "pcms-contoso-non-prod"
    env         = "dev2"
    deployed_by = "Terraform"
}
