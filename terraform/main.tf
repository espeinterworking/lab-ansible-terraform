terraform {
  required_providers {
    eveng = {
      source  = "CorentinPtrl/eveng"
      version = "~> 0.1"
    }
  }
}

# Recuerda verificar si la IP de tu EVE-NG sigue siendo la misma
provider "eveng" {
  host     = "http://10.9.9.82"
  username = "admin"
  password = "eve"
}

# ==========================================
# 1. LABORATORIO Y GESTIÓN
# ==========================================
resource "eveng_lab" "lab_ansible_terraform" {
  name        = "lab_ansible_terraform"
  description = "Laboratorio Ansible Terraform"
}

resource "eveng_network" "cloud_gestion" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Management_Cloud"
  type     = "pnet0"
  left     = 450
  top      = 50
}

# ==========================================
# 2. NODOS (ROUTERS CISCO IOL)
# ==========================================
resource "eveng_node" "pe_1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "PE_1"
  template = "iol"
  type     = "iol"
  left     = 200
  top      = 400
}

resource "eveng_node" "p_2" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "P_2"
  template = "iol"
  type     = "iol"
  left     = 450
  top      = 200
}

resource "eveng_node" "rr_1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "RR_1"
  template = "iol"
  type     = "iol"
  left     = 450
  top      = 400
}

resource "eveng_node" "p_1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "P_1"
  template = "iol"
  type     = "iol"
  left     = 450
  top      = 600
}

resource "eveng_node" "pe_2" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "PE_2"
  template = "iol"
  type     = "iol"
  left     = 700
  top      = 400
}

# ==========================================
# 3. CONEXIONES DE GESTIÓN (Puerto e0/3 para Ansible)
# ==========================================
resource "eveng_node_link" "mgmt_pe_1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.cloud_gestion.id
  source_node_id = eveng_node.pe_1.id
  source_port    = "e0/3"
}

resource "eveng_node_link" "mgmt_p_2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.cloud_gestion.id
  source_node_id = eveng_node.p_2.id
  source_port    = "e0/3"
}

resource "eveng_node_link" "mgmt_rr_1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.cloud_gestion.id
  source_node_id = eveng_node.rr_1.id
  source_port    = "e0/3"
}

resource "eveng_node_link" "mgmt_p_1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.cloud_gestion.id
  source_node_id = eveng_node.p_1.id
  source_port    = "e0/3"
}

resource "eveng_node_link" "mgmt_pe_2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.cloud_gestion.id
  source_node_id = eveng_node.pe_2.id
  source_port    = "e0/3"
}

# ==========================================
# 4. REDES LÓGICAS (BRIDGES PARA ENLACES P2P)
# ==========================================
resource "eveng_network" "net_pe1_p2" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_PE1_P2"
  type     = "bridge"
  left     = 200
  top      = 400
}

resource "eveng_network" "net_pe1_p1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_PE1_P1"
  type     = "bridge"
  left     = 200
  top      = 400
}

resource "eveng_network" "net_p2_rr1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_P2_RR1"
  type     = "bridge"
  left     = 450
  top      = 200
}

resource "eveng_network" "net_rr1_p1" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_RR1_P1"
  type     = "bridge"
  left     = 450
  top      = 400
}

resource "eveng_network" "net_p2_pe2" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_P2_PE2"
  type     = "bridge"
  left     = 700
  top      = 400
}

resource "eveng_network" "net_p1_pe2" {
  lab_path = eveng_lab.lab_ansible_terraform.path
  name     = "Net_P1_PE2"
  type     = "bridge"
  left     = 700
  top      = 400
}

# ==========================================
# 5. ENLACES DE DATOS (Mapeo exacto de la imagen)
# ==========================================

# Enlace: PE_1 (e0/1) <---> P_2 (e0/0)
resource "eveng_node_link" "link_pe1_p2_pe1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_pe1_p2.id
  source_node_id = eveng_node.pe_1.id
  source_port    = "e0/1"
}
resource "eveng_node_link" "link_pe1_p2_p2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_pe1_p2.id
  source_node_id = eveng_node.p_2.id
  source_port    = "e0/0"
}

# Enlace: PE_1 (e0/2) <---> P_1 (e0/0)
resource "eveng_node_link" "link_pe1_p1_pe1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_pe1_p1.id
  source_node_id = eveng_node.pe_1.id
  source_port    = "e0/2"
}
resource "eveng_node_link" "link_pe1_p1_p1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_pe1_p1.id
  source_node_id = eveng_node.p_1.id
  source_port    = "e0/0"
}

# Enlace: P_2 (e0/1) <---> RR_1 (e0/0)
resource "eveng_node_link" "link_p2_rr1_p2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p2_rr1.id
  source_node_id = eveng_node.p_2.id
  source_port    = "e0/1"
}
resource "eveng_node_link" "link_p2_rr1_rr1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p2_rr1.id
  source_node_id = eveng_node.rr_1.id
  source_port    = "e0/0"
}

# Enlace: RR_1 (e0/1) <---> P_1 (e0/1)
resource "eveng_node_link" "link_rr1_p1_rr1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_rr1_p1.id
  source_node_id = eveng_node.rr_1.id
  source_port    = "e0/1"
}
resource "eveng_node_link" "link_rr1_p1_p1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_rr1_p1.id
  source_node_id = eveng_node.p_1.id
  source_port    = "e0/1"
}

# Enlace: P_2 (e0/2) <---> PE_2 (e0/1)
resource "eveng_node_link" "link_p2_pe2_p2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p2_pe2.id
  source_node_id = eveng_node.p_2.id
  source_port    = "e0/2"
}
resource "eveng_node_link" "link_p2_pe2_pe2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p2_pe2.id
  source_node_id = eveng_node.pe_2.id
  source_port    = "e0/1"
}

# Enlace: P_1 (e0/2) <---> PE_2 (e0/0)
resource "eveng_node_link" "link_p1_pe2_p1" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p1_pe2.id
  source_node_id = eveng_node.p_1.id
  source_port    = "e0/2"
}
resource "eveng_node_link" "link_p1_pe2_pe2" {
  lab_path       = eveng_lab.lab_ansible_terraform.path
  network_id     = eveng_network.net_p1_pe2.id
  source_node_id = eveng_node.pe_2.id
  source_port    = "e0/0"
}