class S3Controller < ApplicationController
  def getPresignedUrl
    presigned_object = S3_BUCKET.presigned_post(
      key: "#{params[:workflow_id]}/#{params[:filename]}",
      success_action_status: '201',
      acl: 'public-read'
    )
    render json: { url: presigned_object.url, fields: presigned_object.fields }
  end
end