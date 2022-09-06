provider "google" {
  project = "fine-bit-361518"
  region  = "us-west1"
  zone    = "us-west1-b"
}

resource "google_compute_network" "vpc_network" {
  name                    = "bc-network"
  auto_create_subnetworks = "true"
}

resource "google_container_cluster" "bootcamp" {
  name = "bc-gke"

  remove_default_node_pool = true
  initial_node_count       = 1

  network = google_compute_network.vpc_network.name
}

resource "google_service_account" "nodepool" {
  account_id   = "bc-serviceaccount"
  display_name = "BC Service Account"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "bc-node-pool"
  cluster    = google_container_cluster.bootcamp.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    service_account = google_service_account.nodepool.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
