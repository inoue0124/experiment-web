class S3Controller < ApplicationController

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

  
  def download
    disclose_bucket = 'disclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    data = s3_client.get_object(bucket: disclose_bucket, key: params[:key]).body

    send_data data.read, filename: params[:file_name], disposition: 'attachment', type: params[:type]
  end


  def upload    
    undisclose_bucket = 'undisclose.experiment-web'

    s3_client = Aws::S3::Client.new()
    data = params[:file]

    s3_client.put_object(bucket: undisclose_bucket, key: params[:key], body: data.read) 
  end
end