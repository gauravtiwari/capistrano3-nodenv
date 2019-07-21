# Capistrano::nodenv

This gem provides idiomatic nodenv support for Capistrano 3.x (and 3.x
*only*).

## Please Note

If you want to use this plugin with Cap 2.x, please use 1.x version of the gem.
Source code and docs for older integration is available in [another repo](https://github.com/yyuu/nodenv)

Thanks a lot to [@yyuu](https://github.com/yyuu) for merging his gem with official one.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', '~> 3.9'
    gem 'capistrano-nodenv', '~> 2.1'

And then execute:

    $ bundle install

## Usage

    # Capfile
    require 'capistrano/nodenv'


    # config/deploy.rb
    set :nodenv_type, :user # or :system, depends on your nodenv setup
    set :nodenv_node, '2.4.2'

    # in case you want to set node version from the file:
    # set :nodenv_node, File.read('.node-version').strip

    set :nodenv_prefix, "nodenv_ROOT=#{fetch(:nodenv_path)} nodenv_VERSION=#{fetch(:nodenv_node)} #{fetch(:nodenv_path)}/bin/nodenv exec"
    set :nodenv_map_bins, %w{rake gem bundle node rails}
    set :nodenv_roles, :all # default value

If your nodenv is located in some custom path, you can use `nodenv_custom_path` to set it.

### Defining the node version

To set the node version explicitly, add `:nodenv_node` to your Capistrano configuration:

    # config/deploy.rb
    set :nodenv_node, '2.4.2'

Alternatively, allow the remote host's `nodenv` to [determine the appropriate node version](https://github.com/nodenv/nodenv#choosing-the-node-version) by omitting `:nodenv_node`. This approach is useful if you have a `.node-version` file in your project.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
