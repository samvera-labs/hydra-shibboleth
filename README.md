# Hydra::Shibboleth

A Rails engine to add Shibboleth auth with LDAP/Active Directory groups.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hydra-shibboleth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-shibboleth

## Usage

TODO: Write usage instructions here

## Development

If you are modifying the hydra-shibboleth gem and want to run the test suite, follow these steps to setup the test environment:

  $ bundle install
  $ rake engine_cart:generate
  $ rake spec

## Contributing

If you're working on a PR for this project, create a feature branch off of `main`.

This repository follows the [Samvera Community Code of Conduct](https://samvera.atlassian.net/wiki/spaces/samvera/pages/405212316/Code+of+Conduct) and [language recommendations](https://github.com/samvera/maintenance/blob/master/templates/CONTRIBUTING.md#language).  Please ***do not*** create a branch called `master` for this repository or as part of your pull request; the branch will either need to be removed or renamed before it can be considered for inclusion in the code base and history of this repository.
