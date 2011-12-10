require 'base64'

class S3UploadsController < ApplicationController

  # The plugin flash script has to be able to access this controller, so don't block it with authentication!
  # You can delete the following line if you have no authentication in your app.

  skip_before_filter  :<*** your authentication filter, if any, goes here!>, [:only => "index"]


  # --- no code for modification below here ---

  # Sigh.  OK that's not completely true - you might want to look at https and expiration_date below.
  #        Possibly these should also be configurable from S3Config...

  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature
  
  def index
    bucket          = S3SwfUpload::S3Config.bucket
    access_key_id   = S3SwfUpload::S3Config.access_key_id
    acl             = S3SwfUpload::S3Config.acl
    secret_key      = S3SwfUpload::S3Config.secret_access_key
    key             = params[:key]
    content_type    = params[:content_type]
    https           = 'false'
    error_message   = ''
    expiration_date = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')

    policy = Base64.encode64(
"{
    'expiration': '#{expiration_date}',
    'conditions': [
        {'bucket': '#{bucket}'},
        {'key': '#{key}'},
        {'acl': '#{acl}'},
        {'Content-Type': '#{content_type}'},
        {'Content-Disposition': 'attachment'},
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
    ]
}").gsub(/\n|\r/, '')

    signature = b64_hmac_sha1(secret_key, policy)

    respond_to do |format|
      format.xml {
        render :xml => {
          :policy          => policy,
          :signature       => signature,
          :bucket          => bucket,
          :accesskeyid     => access_key_id,
          :acl             => acl,
          :expirationdate  => expiration_date,
          :https           => https,
          :errorMessage    => error_message.to_s
        }.to_xml
      }
    end
  end
end
