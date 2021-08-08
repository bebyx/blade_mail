resource "aws_eip" "ip-blade-mail" {
  instance = aws_instance.blade-mail.id
}
