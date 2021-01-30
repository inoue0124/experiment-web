Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_ACCESS_KEY']
  ),
})

S3_DISCLOSED_BUCKET = 'disclose.experiment-web'
S3_UNDISCLOSED_BUCKET = 'undisclose.experiment-web'

S3_DISCLOSE_ASSESSMENT_URL = "https://s3-ap-northeast-1.amazonaws.com/" + S3_DISCLOSED_BUCKET + "/assessment/"
S3_DISCLOSE_INSTRUCTION_URL = "https://s3-ap-northeast-1.amazonaws.com/" + S3_DISCLOSED_BUCKET + "/instruction/"