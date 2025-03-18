# frozen_string_literal: true

class ModelStringCollection < Lutaml::Model::Serializable
  attribute :ary, :string, collection: true
end

RSpec.describe ModelStringCollection do
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
        expect(model.to_yaml).to eq expected_yaml
      end

      it "serializes to json" do
        expect(model.to_json).to eq expected_json
      end
    end

    # No casting is expected for a plain string collection
    context "when given a comma-separated string" do
      let(:input) { input_string }

      it "does no casting for yaml" do
        expect(model.to_yaml).to eq "---\nary: a, b, c\n"
      end

      it "does no casting for json" do
        expect(model.to_json).to eq "{\"ary\":\"a, b, c\"}"
      end
    end
  end

  describe "deserialization" do
    describe ".from_yaml" do
      subject(:model) { described_class.from_yaml(expected_yaml) }
      its(:ary) { is_expected.to eq(input_array) }
    end

    describe ".from_json" do
      subject(:model) { described_class.from_json(expected_json) }
      its(:ary) { is_expected.to eq(input_array) }
    end
  end
end
