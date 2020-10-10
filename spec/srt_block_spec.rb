require 'srt_subtitle_validator/srt_block'

RSpec.describe SrtSubtitleValidator::SrtBlock do
  let(:args) { "5\n00:00:14,120 --> 00:00:17,520\ntřista-třicet tři písmen" }
  describe "initialize" do
    subject { described_class.new(*args) }
    context "one argument" do
      it { is_expected.to have_attributes dialog_number: 5 }
    end

    context "three arguments" do
      let(:args) { ["5", "00:00:14,120 --> 00:00:17,520", "třista-třicet tři písmen"] }
      it { is_expected.to have_attributes dialog_number: 5 }
    end

    context "more arguments" do
      let(:args) { %w[5 time x x x] }
      it { expect { subject }.to raise_exception ArgumentError }
    end
  end

  describe "#to_s" do
    let(:entity) { described_class.new(*args)}
    subject { entity.to_s }
    it { is_expected.to eq "#{args}\n\n" }
  end
end