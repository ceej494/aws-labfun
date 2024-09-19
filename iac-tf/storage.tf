resource "aws_s3_bucket" "my_mongo_backup_bucket" {
  bucket = "my-mongo-backup-bucket"

  tags = {
    Name = "my-mongo-backup-bucket"
  }
}

resource "aws_s3_bucket_policy" "mongo_backup_public_policy" {
  bucket = aws_s3_bucket.my_mongo_backup_bucket.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-mongo-backup-bucket/mongodb-backups/*"
        }
    ]
}
EOF
}

resource "aws_ecr_repository" "my_ecr" {
  name                 = "labfun"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}