data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["137112412989"]
}

resource "aws_key_pair" "ssh-key-pair" {
  key_name   = "testing-v2"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.myapp_sg_id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key-pair.key_name

  user_data = file("${path.module}/entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}