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
//      image = "debian-cloud/debian-10"
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
    network = "default"
    access_config {
    }
  }
  metadata_startup_script = "apt-get -y update && apt-get -y upgrade"
}
