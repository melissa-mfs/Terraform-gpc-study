terraform {
  required_version = ">=0.11.1"
}

//configura o projeto GCP
provider "google" {
  credentials = "${file("${var.key_path}")}"
  project = "${var.gcp_project_id}"
  region = "${var.gcp_region}"
}


//cria a VM com o Google Compute Engine
resource "google_compute_instance" "chapter1" {
  name         = "${var.instance_name1}"
  machine_type = "${var.machine_type1}"
  zone         = "${var.gcp_zone1}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  //instala o servidor apache
  metadata_startup_script = "sudo apt-get update; sudo apt-get install apache2 -y; echo Testando > /var/www/html/index.html"

  //habilita a rede para a VM bem como um IP público
  network_interface {
    network = "default"
    access_config {
      
    }
  }
}

//cria o Firewall para a VM
resource "google_compute_firewall" "cp1_firewall" {
  name = "${var.fw_name1}"
  network = "default"
  allow {
    protocol = "tcp"
    ports = "${var.ports_cp1}"
  }
}


output "name" {
  value = google_compute_instance.chapter1.name
}

output "size" {
  value = google_compute_instance.chapter1.machine_type
}

output "public_ip" {
  value = google_compute_instance.chapter1.network_interface[0].access_config[0].nat_ip
}

output "firewall_ports" {
  value = google_compute_firewall.cp1_firewall.allow
}

