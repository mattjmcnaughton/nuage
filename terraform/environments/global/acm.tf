# TODO: Read these from s3 instead of from the file system.
resource "aws_acm_certificate" "mattjmcnaughton_com" {
  # The PEM formatted private key - privkey.pem
  private_key = file(var.path_to_mattjmcnaughton_com_private_key)
  # The PEM formatted public key - cert.pem
  certificate_body = file(var.path_to_mattjmcnaughton_com_certificate_body)
  # The Certificate chain - chain.pem
  certificate_chain = file(var.path_to_mattjmcnaughton_com_certificate_chain)
}
