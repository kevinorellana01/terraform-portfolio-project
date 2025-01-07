provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "nextjs-bucket" {
  bucket = "nextjs-portfolio-bucket-ko"
}

# Ownership Control
resource "aws_s3_bucket_ownership_controls" "nextjs-bucket-ownership-controls" {
  bucket = aws_s3_bucket.nextjs-bucket.id
  
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "nextjs-bucket-public-access-block" {
  bucket = aws_s3_bucket.nextjs-bucket.id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "nextjs-bucket-acl" {
  
  depends_on = [ 
    aws_s3_bucket_ownership_controls.nextjs-bucket-ownership-controls,
    aws_s3_bucket_public_access_block.nextjs-bucket-public-access-block
   ]

  bucket = aws_s3_bucket.nextjs-bucket.id
  acl = "public-read"  
}

# Bucket Policy
resource "aws_s3_bucket_policy" "nextjs-bucket-policy" {
  bucket = aws_s3_bucket.nextjs-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject",
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.nextjs-bucket.arn}/*"
      }
    ]
  })  
}

# Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "origin-access-identity" {
  comment = "OAI for Next.js Portfolio site"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "nextjs-distribution" {
  origin {
    domain_name = aws_s3_bucket.nextjs-bucket.bucket_regional_domain_name
    origin_id   = "S3-nextjs-portfolio-bucket"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin-access-identity.cloudfront_access_identity_path
    }
  }
  enabled = true
  is_ipv6_enabled = true
  comment = "Next.js Portfolio site"
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-nextjs-portfolio-bucket"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}