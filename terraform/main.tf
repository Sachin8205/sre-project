provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "sre_terraform" {
  metadata {
    name = "terraform-demo"
  }
}

resource "kubernetes_deployment" "sre_app" {
  metadata {
    name = "terraform-sre-app"

    labels = {
      app = "terraform-sre-app"
    }

    namespace = kubernetes_namespace.sre_terraform.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "terraform-sre-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "terraform-sre-app"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sre_service" {
  metadata {
    name = "terraform-sre-service"

    namespace = kubernetes_namespace.sre_terraform.metadata[0].name
  }

  spec {
    selector = {
      app = "terraform-sre-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}