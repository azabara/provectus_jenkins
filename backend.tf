#terraform {
#  backend "s3" {
#    bucket = "bucket-of-tulips"
#    key    = "global/s3/terrafrom.tfstate"
#    region = "eu-central-1"
#    dynamodb_table = "tf-be"
#    encrypt = "true"
#  }
#}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "bucket-of-tulips"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }  

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terrafrom_locks" {
    name         = "tf-be"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
         name    = "LockID"
          type   = "S"
    }
}
