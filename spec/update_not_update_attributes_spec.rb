require 'spec_helper'
require 'rubocop'
require './lib/update_not_update_attributes'

describe RuboCop::Cop::Style::UpdateNotUpdateAttributes do
  # These helper methods are from https://github.com/bbatsov/rubocop/blob/4b26354497f32da8d771f35c66b2f47224f9674b/spec/support/cop_helper.rb#L10
  def inspect_source(cop, source, file = nil)
    if source.is_a?(Array) && source.size == 1
      fail "Don't use an array for a single line of code: #{source}"
    end
    RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
    processed_source = parse_source(source, file)
    fail 'Error parsing example code' unless processed_source.valid_syntax?
    _investigate(cop, processed_source)
  end

  def parse_source(source, file = nil)
    source = source.join($RS) if source.is_a?(Array)

    if file&.respond_to?(:write)
      file.write(source)
      file.rewind
      file = file.path
    end

    RuboCop::ProcessedSource.new(source, 2.6, file)
  end

  def _investigate(cop, processed_source)
    team = RuboCop::Cop::Team.new([cop], nil, raise_error: true)
    report = team.investigate(processed_source)
    @last_corrector = report.correctors.first || RuboCop::Cop::Corrector.new(processed_source)
    report.offenses
  end

  def autocorrect_source(source, file = nil)
    RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
    RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
    cop.instance_variable_get(:@options)[:auto_correct] = true
    processed_source = parse_source(source, file)
    _investigate(cop, processed_source)

    @last_corrector.rewrite
  end
  # end helper methods

  context 'with no exceptions' do
    [
      'user.update full_name: "joe"',
      'user.update! email: "joe@email.com"',
    ].each do |source|
      it "isn't offended by update or update!" do
        cop = described_class.new
        inspect_source(cop, source)
        expect(cop.offenses.size).to eq(0)
      end
    end
  end

  context 'with exceptions' do
    [
      'user.update_attributes full_name: "joe"',
      'user.update_attributes! full_name: "joe"',
      'user.dog.update_attributes full_name: "joe"',
      'user.dog.update_attributes! full_name: "joe"',
      ['users.each do |user|', 'user.update_attributes email: "joe@email.com"', 'end'],
      ['users.each do |user|', 'user.campaign.update_attributes email: "joe@email.com"', 'end'],
      ['users.each do |user|', 'user.update_attributes! email: "joe@email.com"', 'end'],
      ['users.each do |user|', 'user.campaign.update_attributes! email: "joe@email.com"', 'end'],
    ].each do |source|
      it "is offended by source `#{source}`" do
        cop = described_class.new
        inspect_source(cop, source)
        expect(cop.offenses.size).to eq(1)
      end
    end
  end

  context 'auto-corrects' do
    let(:cop) { described_class.new }

    it 'update_attributes to update' do
      new_source = autocorrect_source('user.update_attributes full_name: "joe"')
      expect(new_source).to eq('user.update full_name: "joe"')
    end

    it 'update_attributes! to update!' do
      new_source = autocorrect_source('user.update_attributes! full_name: "joe"')
      expect(new_source).to eq('user.update! full_name: "joe"')
    end
  end
end
