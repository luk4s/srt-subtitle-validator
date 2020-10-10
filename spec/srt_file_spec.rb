require 'srt_subtitle_validator/srt_file'

RSpec.describe SrtSubtitleValidator::SrtFile do
  let(:subtitle_file) { fixture_file("cp1250-crlf.srt") }
  let(:entity) { described_class.new File.read(subtitle_file) }
  describe "#valid?" do
    subject { entity.valid? }
    it "non-UTF8 file" do
      expect { subject }.to raise_error ArgumentError, /invalid byte sequence/
    end

    context "utf8 file" do
      let(:subtitle_file) { fixture_file("utf8-crlf.srt") }
      it { is_expected.to eq true }
    end

    context "no srt file" do
      let(:entity) { SrtSubtitleValidator::SrtFile.new"invalid file\n" }

      it do
        is_expected.to eq false
        expect(entity.errors).to include "File is zero size"
      end
    end

    context "missing block" do
      let(:subtitle_file) { fixture_file("utf8-invalid-blocks.srt") }
      it do
        is_expected.to eq false
        expect(entity.errors).to include "Numbers sequence is corrupted"
      end
    end
  end
end