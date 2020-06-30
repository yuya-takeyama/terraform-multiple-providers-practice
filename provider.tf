provider "aws" {
  version     = "~> 2.68.0"
  region      = "ap-northeast-1"
  max_retries = 3
}

provider "github" {
  version = "2.9.0"
  owner   = "yuya-takeyama"
}
