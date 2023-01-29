resource "google_service_account" "packer_account" {
  account_id   = var.packer_account_id
  display_name = var.packer_account_name
}

resource "google_project_iam_member" "packer_compute_binding" {
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.packer_account.email}"
  project = var.project
}

resource "google_project_iam_member" "packer_service_account_binding" {
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.packer_account.email}"
  project = var.project
}

resource "google_project_iam_custom_role" "image_admin" {
  role_id     = "imageAdmin"
  title       = "Image Admin"
  description = "Image Admin"
  permissions = [
    "compute.images.create",
    "compute.images.delete",
    "compute.images.get",
    "compute.images.list"
  ]
}

resource "google_project_iam_binding" "packer_iam_binding" {
  role = "projects/${var.project}/roles/${google_project_iam_custom_role.image_admin.role_id}"

  members = [
    "serviceAccount:${google_service_account.packer_account.email}",
  ]
  project = var.project
}

resource "google_service_account_key" "packer_account_key" {
  service_account_id = google_service_account.packer_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_secret_manager_secret" "packer_secret" {
  secret_id = "packer-secret"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "packer_service_account_key" {
  secret      = google_secret_manager_secret.packer_secret.id
  secret_data = base64decode(google_service_account_key.packer_account_key.private_key)
}


resource "google_secret_manager_secret" "packer_account_email" {
  secret_id = "packer-account-email"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "packer_service_account_name" {
  secret      = google_secret_manager_secret.packer_account_email.id
  secret_data = google_service_account.packer_account.email
}