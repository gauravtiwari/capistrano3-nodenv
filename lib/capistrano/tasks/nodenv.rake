namespace :nodenv do
  task :validate do
    on release_roles(fetch(:nodenv_roles)) do |host|
      nodenv_node = fetch(:nodenv_node)
 
      if nodenv_node.nil?
        info 'nodenv: nodenv_node is not set; node version will be defined by the remote hosts via nodenv'
      end

      # don't check the nodenv_node_dir if :nodenv_node is not set (it will always fail)
      unless nodenv_node.nil? || (test "[ -d #{fetch(:nodenv_node_dir)} ]")
        warn "nodenv: #{nodenv_node} is not installed or not found in #{fetch(:nodenv_node_dir)} on #{host}"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!({ nodenv_root: fetch(:nodenv_path), nodenv_version: fetch(:nodenv_node) })
    nodenv_prefix = fetch(:nodenv_prefix, proc { "#{fetch(:nodenv_path)}/bin/nodenv exec" })
    SSHKit.config.command_map[:nodenv] = "#{fetch(:nodenv_path)}/bin/nodenv"

    fetch(:nodenv_map_bins).uniq.each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(nodenv_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'nodenv:validate'
  after stage, 'nodenv:map_bins'
end

namespace :load do
  task :defaults do
    set :nodenv_path, -> {
      nodenv_path = fetch(:nodenv_custom_path)
      nodenv_path ||= if fetch(:nodenv_type, :user) == :system
        '/usr/local/nodenv'
      else
        '$HOME/.nodenv'
      end
    }


    set :nodenv_roles, fetch(:nodenv_roles, :all)
    set :nodenv_node_dir, -> { "#{fetch(:nodenv_path)}/versions/#{fetch(:nodenv_node)}" }
    set :nodenv_map_bins, %w{node nodejs}
  end
end
