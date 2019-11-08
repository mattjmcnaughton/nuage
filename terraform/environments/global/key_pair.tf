resource "aws_key_pair" "mattjmcnaughton_personal_rsa" {
  key_name = "mattjmcnaughton_personal_rsa"
  public_key = file("~/.ssh/mattjmcnaughton_personal_rsa.pub")
}
