# 🌐 Automatización de Red Core MPLS (NetDevOps IaC)

Infraestructura como Código (IaC) para el despliegue y configuración automatizada de una red Core MPLS utilizando **Terraform** y **Ansible**.

## 🏗️ Arquitectura
* **Despliegue Físico:** EVE-NG (Cisco IOS) gestionado con Terraform.
* **Fases de Automatización (Ansible):**
  1. Direccionamiento IP (Transito y Loopbacks).
  2. IGP OSPFv2 (Punto a punto + LDP Sync).
  3. MPLS LDP (Conmutación de etiquetas).
  4. iBGP VPNv4 (Route Reflector AS 15).
  5. VRF Pinto & eBGP (RD/RT 15:1).

## 🚀 Guía de Despliegue
1. Configurar IP y credenciales locales de EVE-NG en `terraform/main.tf`.
2. Desplegar topología: `cd terraform && terraform init && terraform apply -auto-approve`.
3. Configurar IPs locales de administración en `ansible/inventario.ini`.
4. Ejecutar playbooks de Ansible en orden secuencial (1 al 5).
