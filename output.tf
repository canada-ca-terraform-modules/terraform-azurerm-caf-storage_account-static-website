output "static-website-sa" {
  description = "Outputs the entire storage account associated with the static website"
  value = module.storage-account.storage-account-object
}

output "static-website-fdn" {
  description = "Outputs the entire front door profile module associated with the static website"
  value = module.front_door.front-door-object
}

