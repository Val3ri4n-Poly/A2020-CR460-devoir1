// Configuration du réseau
resource "google_compute_network" "project_id" {
  name                    = "devoir1"
  auto_create_subnetworks = "false"
}

// Configuration des sous-réseaux
// Sous-réseau 1
resource "google_compute_subnetwork" "prod-dmz" {
  name          = "prod-dmz"
  ip_cidr_range = "172.16.3.0/24"
  region        = var.region
  network       = google_compute_network.project_id.self_link
}

// Sous-réseau 2
resource "google_compute_subnetwork" "prod-interne" {
  name          = "prod-interne"
  ip_cidr_range = "10.0.3.0/24"
  region        = var.region
  network       = google_compute_network.project_id.self_link
}

// Sous-réseau 3
resource "google_compute_subnetwork" "prod-traitement" {
  name          = "prod-traitement"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.project_id.self_link
}

// Règles de pare-feu
// Règles pour autoriser le trafic vers les instances
resource "google_compute_firewall" "http-public" {
  name    = "http-public"
  network = google_compute_network.project_id.name
  target_tags = ["public-web"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "ssh-interne" {
  name    = "ssh-interne"
  network = google_compute_network.project_id.name
  target_tags = ["interne"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["10.0.3.0/24"]
}

resource "google_compute_firewall" "tcp-traitement" {
  name    = "tcp-traitement"
  network = google_compute_network.project_id.name
  target_tags = ["traitement"]
  allow {
    protocol = "tcp"
    ports    = ["2846", "5462"]
  }
  source_ranges = ["10.0.2.0/24"]
}
