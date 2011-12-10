class Image < ActiveRecord::Base
  belongs_to :order

  has_attached_file :content,
                    :storage => :s3,
:s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
:path => ":date/:order_id/:filename",
:bucket => S3SwfUpload::S3Config.bucket,
  :url => ':s3_domain_url'



  
end
