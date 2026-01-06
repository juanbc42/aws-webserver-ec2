resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets_list

  bucket = "${each.key}-${random_id.default.hex}"
  region = var.region
  tags   = var.tags
}
