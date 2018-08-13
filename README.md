# cw-style

charity: water shared code style configs for RuboCop. Forked from https://github.com/percy/percy-style.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test, :development do
  gem 'cw-style'
end
```

Or, for a Ruby library, add this to your gemspec:

```ruby
spec.add_development_dependency 'cw-style'
```

And then run:

```bash
$ bundle install
```

## Usage

Create a `.rubocop.yml` with the following directives:

```yaml
inherit_gem:
  cw-style:
    - default.yml
```

Now, run:

```bash
$ bundle exec rubocop
```

You do not need to include rubocop directly in your application's dependencies. Cw-style will include a specific version of `rubocop` and `rubocop-rspec` that is shared across all projects.

## Gem Versioning
- The gem version needs to be bumped along with any changes to the code.
  - Manually bump the version number in [version.rb](https://github.com/charitywater/cw-style/blob/master/lib/charity_water/style/version.rb)
- The gemfury-hosted gem is automatically updated when changes to this repo are merged.
- Apps that include this gem as a dependency need to be updated to use the latest version of the gem.
  - When making changes to this repo, be sure to update the gem version in all apps that use this gem by running `bundle update cw-style` and commiting the Gemfile.lock changes.
  
Apps that use this gem:
- [maji](https://github.com/charitywater/maji/blob/master/Gemfile)
- [cw-picha](https://github.com/charitywater/cw-picha/blob/master/Gemfile)
- [stripe_netsuite_sync](https://github.com/charitywater/stripe_netsuite_sync/blob/master/Gemfile)
- [dispatch](https://github.com/charitywater/dispatch/blob/master/Gemfile)
- [crm_sync](https://github.com/charitywater/crm_sync/blob/master/Gemfile)
