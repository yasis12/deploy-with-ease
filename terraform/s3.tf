//this page is named s3 becuase we are using an s3 bucket

//initializes our bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "useragent-info-parser-bucket1212"
  force_destroy = true

  tags = {
    Name        = "useragent-info-parser-bucket1212"
    Environment = "dev"
  }
}

//This changes the policy of the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.bucket.arn}/*",
        Principal = "*"
      }
    ]
  })
}

//Code to host our bucket in aws using our bucket??
resource "aws_s3_bucket_website_configuration" "bucket_website_configuration" {
  bucket = aws_s3_bucket.bucket.id 
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

//AWS public access block. By default it is blocked from all public access. 
//This is needed to give public access to the website
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}