# This Terraform script provisions a compute instance

resource "random_id" "random_id" {
  byte_length = 2
}

# Create Compute Instance

resource "oci_core_instance" "compute_instance" {
  count               = var.num_nodes
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name = "${var.name_prefix}-${random_id.random_id.dec}"
  #image = var.image_ocid

  shape = var.instance_shape
  shape_config {
    memory_in_gbs             = 16
    ocpus                     = 1
  }

  metadata = {
    ssh_authorized_keys = "${tls_private_key.public_private_key_pair.public_key_openssh}"
    # user_data: "${base64encode(data.local_file.cloud_init.content)}"

    # user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    #   wallet_content = var.wallet_content
    # }))

  }

  #subnet_id = var.private_subnet_ocid
  freeform_tags = var.freeform_tags

  create_vnic_details {
    subnet_id        = var.public_subnet_ocid
    display_name     = "${var.name_prefix}-${random_id.random_id.dec}"
    assign_public_ip = true
    nsg_ids = [var.compute_nsg_id]
    #hostname_label   = "${var.name_prefix}-${random_id.random_id.dec}-${count.index}"
  }

  source_details {
    source_type = "image"
    #source_id   = data.oci_core_images.compute_images.images[0].id
    source_id   = var.source_id
  }

  timeouts {
    create = "60m"
  }
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm   = "RSA"
}

resource "null_resource" "download_wallet" {
  depends_on = [oci_core_instance.compute_instance[0]]

  provisioner "remote-exec" {
    inline = [
      "echo 'base64로 인코딩된 wallet을 디코딩하여 wallet.zip 파일로 저장'",
      "echo ${var.wallet_content} | base64 --decode > /home/opc/demo/wallet.zip",

      "echo 'wallet.zip 파일의 압축해제'",
      "unzip /home/opc/demo/wallet.zip -d /home/opc/demo/wallet",

      "echo 'AI Profile 및 Vector Index 생성'",
      "sql -cloudconfig /home/opc/demo/wallet.zip admin/WelCome123##@myatp_medium @/home/opc/demo/sql/create_profile_vectoridx.sql",
      
      "echo 'ReactJS Frontend .env 파일 생성'",
      "echo VITE_API_URL=http://${oci_core_instance.compute_instance[0].public_ip}:8080 > /home/opc/demo/react-selectairag-chatapp/.env",
      
      "echo 'ReactJS Frontend 빌드'",
      "cd /home/opc/demo/react-selectairag-chatapp && npm run build",
      
      "echo 'ReactJS Frontend 실행'",
      # "cd /home/opc/demo/react-selectairag-chatapp && nohup node server.js > reactjs.log 2>&1 &",
      "sudo systemctl start node-app.service",
      
      "echo 'Spring Boot Backend 실행'",
      # "cd /home/opc/demo/springboot-selectai-api && nohup mvn spring-boot:run > spring.log 2>&1 &"
      "sudo systemctl start spring-app.service"
    ]

    connection {
      type        = "ssh"
      host        = oci_core_instance.compute_instance[0].public_ip
      user        = "opc"
      private_key = "${tls_private_key.public_private_key_pair.private_key_pem}"
    }
  }
}