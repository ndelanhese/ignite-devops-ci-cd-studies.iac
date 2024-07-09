resource "aws_s3_bucket" "s3_test" {
  bucket = "test_pipeline_iac"

  tags = {
    IAC = "True"
  }
}
