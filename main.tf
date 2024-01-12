provider "google" {
  credentials = file("/credentials.json")
  project     = "zinc-strategy-393412"
  region      = "us-central1"  # Vous pouvez changer la région selon votre préférence
}

terraform {
  backend "gcs" {
    credentials = "credentials.json"
    bucket  = "mon_bucket_for_terraform"
    prefix  = "MonBackend"
  }
}

variable "db_password" {
  description = "Mot de passe pour la base de données MySQL"
  type        = string
}

resource "google_sql_database_instance" "mansours" {
  name             = "mansours"
  database_version = "MYSQL_5_7"
  region           = "us-central1"
  deletion_protection = "false"
  settings {
    tier = "db-f1-micro"    
  }
  
}

resource "google_sql_database" "test" {
  name     = "test"
  instance = google_sql_database_instance.mansours.name
}

resource "google_sql_user" "mansour" {
  name     = "mansour"
  instance = google_sql_database_instance.mansours.name
  password = var.db_password
}

output "database_ip" {
  value = google_sql_database_instance.mansours.ip_address
}



