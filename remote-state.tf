module "backend_dynamodb" {
  source         = "./dynamodb"
  table_name     = "DynamoDB-state"
  table_hash_key = "LockID"
  attribute_name = "LockID"
  attribute_type = "S"
}

module "backend_s3" {
  source                          = "./s3"
  bucket_name                     = "statebucket29-1"
  bucket_versioning_configuration = "Enabled"
}

terraform {
  backend "s3" {
    bucket         = "statebucket29-1"
    key            = "dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "DynamoDB-state"
    encrypt        = true
  }
}