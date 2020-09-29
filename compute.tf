// Configuration des instances
// Configuration de l'instance 1
resource "google_compute_instance" "instance1" {
  name         = "canard"
  machine_type = "f1-micro"
  zone = var.zone
  tags = ["public-web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.prod-dmz.name
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
}

// Configuration de l'instance 2
resource "google_compute_instance" "instance2" {
  name         = "mouton"
  machine_type = "f1-micro"
  zone = var.zone
  tags = ["interne"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-interne.name
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade"
}

// Configuration de l'instance 3
resource "google_compute_instance" "instance3" {
  name         = "cheval"
  machine_type = "f1-micro"
  zone = var.zone
  tags = ["traitement"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-traitement.name
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade"
}

// Configuration de l'instance 4
resource "google_compute_instance" "instance4" {
  name         = "fermier"
  machine_type = "f1-micro"
  zone = var.zone
  tags = ["traitement"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-interne.self_link
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade"
}

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
resource "google_compute_firewall" "ssh-public" {
  name    = "ssh-public"
  network = google_compute_network.project_id.name
  target_tags = ["public-web"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "http-public" {
  name    = "http-public"
  network = google_compute_network.project_id.name
  target_tags = ["public-web"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
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
}

resource "google_compute_firewall" "tcp-traitement-2846" {
  name    = "tcp-traitement-2846"
  network = google_compute_network.project_id.name
  target_tags = ["traitement"]
  allow {
    protocol = "tcp"
    ports    = ["2846"]
  }
}

resource "google_compute_firewall" "tcp-traitement-5462" {
  name    = "tcp-traitement-5462"
  network = google_compute_network.project_id.name
  target_tags = ["traitement"]
  allow {
    protocol = "tcp"
    ports    = ["5462"]
  }
}
