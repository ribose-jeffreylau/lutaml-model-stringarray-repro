# frozen_string_literal: true

class StringArray < Lutaml::Model::Type::Value
  def self.cast(value)
    return nil if value.nil?

    value.to_s.split(",").map(&:strip)
  end

  def to_yaml
    value.join(",")
  end

  def to_json(*_args)
    value.join(",")
  end

  def self.from_yaml(value)
    cast(value)
  end

  def self.from_json(value)
    cast(value)
  end
end

class ModelStringAry < Lutaml::Model::Serializable
  attribute :ary, StringArray
end

RSpec.describe ModelStringAry do
  let(:model) { described_class.new }

  let(:input_array) { ["a", "b", "c"] }

  let(:input_string) { "a, b, c" }

  let(:expected_yaml) do
    <<~EOYAML
      ---
      ary:
      - a
      - b
      - c
    EOYAML
  end

  let(:expected_json) do
    '{"ary":["a","b","c"]}'
  end

  describe "#ary" do
    before do
      model.ary = input
    end

    context "when given an array of strings" do
      let(:input) { input_array }

      it "serializes to yaml" do
        #
        # Result is double-wrapped in array.
        #
        # expected: "---\nary:\n- a\n- b\n- c\n"
        #      got: "---\nary:\n- - a\n- - b\n- - c\n"
        #
        expect(model.to_yaml).to eq expected_yaml
      end

      it "serializes to json" do
        #
        # Result is double-wrapped in array.
        #
        # expected: "{\"ary\":[\"a\",\"b\",\"c\"]}"
        #      got: "{\"ary\":[[\"a\"],[\"b\"],[\"c\"]]}"
        #
        expect(model.to_json).to eq expected_json
      end
    end

    context "when given a comma-separated string" do
      let(:input) { input_string }

      it "serializes to yaml" do
        expect(model.to_yaml).to eq expected_yaml
      end

      it "serializes to json" do
        expect(model.to_json).to eq expected_json
      end
    end
  end

  describe "deserialization" do
    describe ".from_yaml" do
      subject(:model) { described_class.from_yaml(expected_yaml) }
      #
      # Lutaml::Model::CollectionTrueMissingError:
      #   May be `collection: true` is missing for `ary` in ModelStringAry
      #
      its(:ary) { is_expected.to eq(input_array) }
    end

    describe ".from_json" do
      subject(:model) { described_class.from_json(expected_json) }
      #
      # Lutaml::Model::CollectionTrueMissingError:
      #   May be `collection: true` is missing for `ary` in ModelStringAry
      #
      its(:ary) { is_expected.to eq(input_array) }
    end
  end
end
