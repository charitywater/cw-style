require 'spec_helper'
require './lib/private_attribute_accessors'

describe RuboCop::Cop::Style::PrivateAttributeAccessors do
  subject(:cop) { described_class.new }

  context 'with private attribute accessors' do
    it 'registers an offense for attr_reader in private scope' do
      expect_offense(<<~RUBY)
        class Example
          private
          attr_reader :foo
          ^^^^^^^^^^^^^^^^ Style/PrivateAttributeAccessors: Do not use private attribute accessors
        end
      RUBY
    end

    it 'registers an offense for attr_writer in private scope' do
      expect_offense(<<~RUBY)
        class Example
          private
          attr_writer :bar
          ^^^^^^^^^^^^^^^^ Style/PrivateAttributeAccessors: Do not use private attribute accessors
        end
      RUBY
    end

    it 'registers an offense for attr_accessor in private scope' do
      expect_offense(<<~RUBY)
        class Example
          private
          attr_accessor :baz
          ^^^^^^^^^^^^^^^^^^ Style/PrivateAttributeAccessors: Do not use private attribute accessors
        end
      RUBY
    end
  end

  context 'with public attribute accessors' do
    it 'does not register an offense for attr_reader in public scope' do
      expect_no_offenses(<<~RUBY)
        class Example
          attr_reader :foo
        end
      RUBY
    end

    it 'does not register an offense for attr_writer in public scope' do
      expect_no_offenses(<<~RUBY)
        class Example
          attr_writer :bar
        end
      RUBY
    end

    it 'does not register an offense for attr_accessor in public scope' do
      expect_no_offenses(<<~RUBY)
        class Example
          attr_accessor :baz
        end
      RUBY
    end
  end

  context 'with unrelated code' do
    it 'does not register an offense for methods in private scope' do
      expect_no_offenses(<<~RUBY)
        class Example
          private

          def some_method
            # do something
          end
        end
      RUBY
    end
  end
end
