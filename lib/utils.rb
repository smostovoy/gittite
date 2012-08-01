module Utils
  def branch_to_dir branch
    branch.gsub('_', '-')
  end

  def run command
    STDOUT << system(command)
  end

  def env
    @env ||= Thread.current['goliath.env']
  end
end