build {
  description = "NGINX Image"

  sources = ["source.azure-arm.nginx", "source.amazon-ebs.nginx", "source.googlecompute.nginx"]

  provisioner "shell" {
    execute_command = "echo '' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    script          = "${path.root}/scripts/nginx.sh"
  }

  provisioner "shell" {
    execute_command = "echo '' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    inline          = ["yum -y install ansible"]
  }

  provisioner "ansible-local" {
    playbook_dir  = "${path.root}/../../ansible"
    playbook_file = "${path.root}/../../ansible/nginx.yml"
  }

}
