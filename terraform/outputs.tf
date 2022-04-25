output "instance_public_ip" {
    description = "EC2 Instance Public IP"
    value = aws_instance.EC2-Instance.public_ip
}

