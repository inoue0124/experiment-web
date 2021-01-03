class S3Controller < ApplicationController
  include ActionController::Streaming
  include Zipline

  def getPresignedUrl
    disclose_bucket = 'disclose.experiment-web'
    s3_bucket = Aws::S3::Resource.new.bucket(disclose_bucket)

    presigned_object = s3_bucket.presigned_post(
      key: params[:key],
      success_action_status: '201',
      acl: 'public-read'
    )
    render json: { url: presigned_object.url, fields: presigned_object.fields }
  end


  def listFiles
    undisclose_bucket = 'undisclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    data = s3_client.list_objects_v2(bucket: undisclose_bucket, prefix: params[:prefix])

    render json: data[:contents]
  end

  
  def download
    disclose_bucket = 'disclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    data = s3_client.get_object(bucket: disclose_bucket, key: params[:key]).body

    send_data data.read, filename: params[:file_name], disposition: 'attachment', type: params[:type]
  end


  def downloadZip
    undisclose_bucket = 'undisclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    fileList = s3_client.list_objects_v2(bucket: undisclose_bucket, prefix: params[:prefix])[:contents]

    zipline(fileList.lazy.map { |file|
      s3_object = s3_client.get_object(bucket: undisclose_bucket, key: file.key)
      p file.key
      [s3_object.body, file.key]
    }, 'sample.zip')
  end


  def upload    
    undisclose_bucket = 'undisclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    data = params[:file]

    s3_client.put_object(bucket: undisclose_bucket, key: params[:key], body: data.read) 
  end
end