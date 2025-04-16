provider "aws" {
  region = "ap-northeast-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}
