endpoints = {
  s3 = "https://storage.yandexcloud.net"
}
bucket = "YOUR_STATE_BUCKET"
key    = "diplom/main.tfstate"
region = "ru-central1"

skip_credentials_validation = true
skip_region_validation      = true
skip_requesting_account_id  = true
use_lockfile                = true

# Credentials: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.
