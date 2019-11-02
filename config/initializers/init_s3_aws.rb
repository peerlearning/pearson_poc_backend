def aws_s3_client(region = Settings.aws_s3_region)
  @_s3_clients ||= {}
  @_s3_clients[region.to_s] ||= Aws::S3::Resource.new({region: region,
                                                       credentials: Aws::Credentials.new(Settings.s3_access_key_id,
                                                       Settings.s3_secret_access_key)})
end