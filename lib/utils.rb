module Utils
  def branch_to_dir branch
    branch.gsub('_', '-')
  end

  def run command
    Goliath.env.logger system(command)
  end
end