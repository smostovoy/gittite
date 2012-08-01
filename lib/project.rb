module Project
  def update_code branch, url
    env.logger.info "deploying to #{@deploy_path}"
    if File.directory? @deploy_path
      env.logger.info "Updating existing directory..."
      env.logger.info `cd #{@deploy_path}; git checkout #{branch}; git reset --hard; git pull`
    else
      env.logger.info "Cloning..."
      env.logger.info `git clone -b #{branch} #{url} #{@deploy_path}`
    end
  end

  def execute_after_deploy_hook
    hook_file = @deploy_path + "/config/gittite.rb"
    Dir.chdir(@deploy_path) do
      env.logger.info "Current dir: #{Dir.pwd}"
      if File.exists? hook_file
        env.logger.info 'Executing after_deploy file...'
        after_deploy = File.read(hook_file)
        instance_eval(after_deploy)
        env.logger.info 'Executed after_deploy file'
      else
        env.logger.info 'no config file in project'
      end
    end
  end

  def clean_removed_branches
    git = Grit::Repo.new(@deploy_path)
    branches = git.remotes.to_a.map { |b| b.name.match(/\w+$/).to_s }.uniq
    env.logger.info 'Looking for obsolete branches.........'
    env.logger.info "Active branches: #{branches.inspect}"
    env.logger.info "#{Dir.pwd}. Dirs to be removed: "
    Dir.foreach(@deploy_to) { |d|
      next if branches.map{|b| branch_to_dir(b)}.include?(d)
      next if ['.','..'].include? d
      next unless File.directory?("#{@deploy_to}/#{d}")
      env.logger.info d
      #FileUtils.rm_r File.join project['deploy_to'], d
    }
  end
end

