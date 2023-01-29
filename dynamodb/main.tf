resource "aws_dynamodb_table" "sl-dynamodb" {
  name           = var.table_name 
  hash_key       = var.table_hash_key
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = var.attribute_name 
    type = var.attribute_type
  }

  tags = {
    Name        = var.table_name
  }
}