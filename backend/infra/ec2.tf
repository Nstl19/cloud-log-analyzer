resource "aws_instance" "logsens_ec2" {
  ami           = "ami-0f5ee92e2d63afc18" 
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.logsens_sg.id]

  iam_instance_profile = "logsens-ec2-role"  

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install docker.io -y
    systemctl start docker
    systemctl enable docker

    # wait for docker to be ready
    sleep 15

    docker run -d --restart always -p 5000:5000 \
      -e BUCKET_NAME=loganalyzer-05458f58\
      -e AWS_DEFAULT_REGION=ap-south-1 \
      nstl19/logsens-api
  EOF

  tags = {
    Name = "logsens-ec2"
  }
}