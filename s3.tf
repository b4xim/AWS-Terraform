resource "aws_s3_bucket" "tf_s3" {
    bucket = "s3-terraform-project-5757"
    
    tags = {
        Name        = "NodeJs-terraform"
        Environment = "Dev"
    }
  
}
resource "aws_s3_object" "tf_s3_object" {
    bucket = aws_s3_bucket.tf_s3.bucket
    for_each = fileset("../public/images", "**")
    key    = "images/${each.key}"
    source = "../public/images/${each.key}"
}