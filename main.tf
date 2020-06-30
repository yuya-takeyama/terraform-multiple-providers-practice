resource "aws_s3_bucket" "bucket" {
  bucket = "yuyat-bucket-created-with-terraform"
  acl    = "public-read"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::yuyat-bucket-created-with-terraform/*"
            ]
        }
    ]
}
EOT

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "github_repository" "repo" {
  name         = "repo-created-with-terraform"
  homepage_url = aws_s3_bucket.bucket.website_endpoint
}

resource "github_repository_file" "index-html" {
  repository = github_repository.repo.name
  file       = "index.html"
  branch     = "master"
  content    = <<EOT
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello, World!</title>
</head>
<body>
  <h1>Hello, World!</h1>
</body>
</html>
EOT
}

resource "github_repository_file" "error-html" {
  repository = github_repository.repo.name
  file       = "error.html"
  branch     = "master"
  content    = <<EOT
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Error!</title>
</head>
<body>
  <h1>Error!</h1>
</body>
</html>
EOT
}

resource "aws_s3_bucket_object" "index-html" {
  key          = "index.html"
  bucket       = aws_s3_bucket.bucket.id
  content      = github_repository_file.index-html.content
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error-html" {
  key          = "error.html"
  bucket       = aws_s3_bucket.bucket.id
  content      = github_repository_file.error-html.content
  content_type = "text/html"
}
