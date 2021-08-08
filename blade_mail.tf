resource "aws_instance" "blade-mail" {
  ami = data.aws_ami.debian-linux-10.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.blade-mail-ssh.key_name

  vpc_security_group_ids = [ aws_security_group.blade-mail.id ]

  tags = {
    Name = data.aws_ami.debian-linux-10.name
  }

  depends_on = [ aws_security_group.blade-mail ]

}

resource "null_resource" "ansible" {

  provisioner "file" {
    source      = "artifacts/gopher.tar.gz"
    destination = "/tmp/gopher.tar.gz"
    connection {
      type        = "ssh"
      user        = "admin"
      private_key = tls_private_key.blade-mail-ssh.private_key_pem
      host        = aws_eip.ip-blade-mail.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = ["echo 'Definitely connected!'"]
    connection {
      type = "ssh"
      user = "admin"
      private_key = tls_private_key.blade-mail-ssh.private_key_pem
      host = aws_eip.ip-blade-mail.public_ip
    }
  }

  provisioner "local-exec" {
    command = "echo 'Come on gopher'"
  }

  depends_on = [ aws_instance.blade-mail ]
}
