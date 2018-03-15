# ConflowSpec

[![Build Status](https://travis-ci.org/fanfilmu/conflow_spec.svg?branch=master)](https://travis-ci.org/fanfilmu/conflow_spec) [![Maintainability](https://api.codeclimate.com/v1/badges/0518fa4b23e959ff779c/maintainability)](https://codeclimate.com/github/fanfilmu/conflow_spec/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/0518fa4b23e959ff779c/test_coverage)](https://codeclimate.com/github/fanfilmu/conflow_spec/test_coverage)

ConflowSpec defines sets of contexts and matchers to easily and responsibly test your [Conflow](https://github.com/fanfilmu/conflow) flows.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "conflow_spec", group: :test
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conflow_spec

## Usage

`ConflowSpec` automatically integrates with RSpec. Tag your specs describing `Conflow::Flow` classes with `conflow: true` metadata.

Note that the jobs will not enqueue using your `#queue` method - so you are still responsible for testing this method on your own.

```ruby
RSpec.describe MyFlow do
  describe ".create", conflow: true do
    subject { described_class.create(id: 115) }

    before { allow_job(DataFetcher, id: 115).to produce([{ type: "User", id: 93 }, { type: "Admin", id: 13 }]) }

    it { is_expected.to run_job(DataFetcher).with_params(id: 115) }

    it { is_expected.to run_job(AdminNotification).with_params(id: 13) }
    it { is_expected.to_not run_job(AdminNotification).with_params(id: 93) }
  end

  describe "#queue" do
    # test your queue method (without conflow: true tag!)
  end
end
```

`run_job` checks if a job of given class was enqueued in the flow. To test hooks, use `allow_job` method - it will stub result of job processing.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fanfilmu/conflow_spec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ConflowSpec project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fanfilmu/conflow_spec/blob/master/CODE_OF_CONDUCT.md).
