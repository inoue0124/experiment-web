class S3Controller < ApplicationController
  include ActionController::Streaming
  include Zipline
  before_action :set_s3_client

  def getPresignedUrl
    s3_bucket = Aws::S3::Resource.new.bucket(S3_DISCLOSE_BUCKET)

    presigned_object = s3_bucket.presigned_post(
      key: params[:key],
      success_action_status: '201',
      acl: 'public-read'
    )
    render json: { url: presigned_object.url, fields: presigned_object.fields }
  end


  def listFiles
    data = @s3_client.list_objects_v2(
      bucket: S3_UNDISCLOSE_BUCKET, 
      prefix: params[:prefix]
    )
    render json: data[:contents]
  end

  
  def download
    data = @s3_client.get_object(
      bucket: S3_DISCLOSE_BUCKET,
      key: params[:key]
    ).body

    send_data data.read, filename: params[:file_name], disposition: 'attachment', type: params[:type]
  end


  def downloadZip
    fileList = @s3_client.list_objects_v2(
      bucket: S3_UNDISCLOSE_BUCKET,
      prefix: params[:prefix]
    )[:contents]

    zipline(fileList.lazy.map { |file|
      s3_object = @s3_client.get_object(
        bucket: S3_UNDISCLOSE_BUCKET,
        key: file.key
      )
      [s3_object.body, file.key]
    }, 'sample.zip')
  end


  def upload
    data = params[:file]

    @s3_client.put_object(
      bucket: S3_UNDISCLOSE_BUCKET,
      key: params[:key],
      body: data.read
    ) 
  end

  private
    def set_s3_client
      @s3_client = Aws::S3::Client.new()
    end
end