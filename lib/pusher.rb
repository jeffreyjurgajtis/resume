class Pusher
  def initialize(&block)
    block.call self
  end

  def self.push!
    new do |pusher|
      pusher.bucket.clear!
      pusher.upload!
    end
  end

  def upload!
    puts 'uploading to s3'

    Helpers.compiled_files.each do |file|
      object_key = file.relative_path_from(Helpers.destination_directory).to_path

      options = {
        acl: :public_read,
        content_encoding: 'utf-8',
        content_type: Rack::Mime.mime_type(file.extname)
      }

      bucket.objects.create(object_key, file, options)
    end

    puts "website can be found at http://#{bucket.name}.s3-website-#{connection.config.ec2_region}.amazonaws.com/"
  end

  def bucket
    @bucket ||= lambda do
      reply = connection.buckets[bucket_name]
      reply.exists? ? reply : provision_bucket
    end.call
  end

  def provision_bucket
    puts 'provisioning bucket'

    connection.buckets.create(bucket_name, acl: :public_read).tap do |reply|
      reply.configure_website do |config|
        config.index_document_suffix = 'index.html'
      end
    end
  end

  def bucket_name
    ENV['AWS_BUCKET_NAME']
  end

  def connection
    @connection ||= AWS::S3.new(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
