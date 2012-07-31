environment :development do
  config['deploy_path'] = '/home/ubuntu/deploy/new'

end

environment :test do
  config['deploy_path'] = '/tmp'
end