require "fileutils"
require 'srt_subtitle_validator/validator'
require "tmpdir"

RSpec.describe SrtSubtitleValidator::Validator do
  let(:subtitle_file) { fixture_file("cp1250-crlf.srt") }
  let(:entity) { described_class.new subtitle_file }

  it "parse cp1250 file" do
    expect { entity.valid? }.not_to raise_exception
  end

  describe "#convert_srt" do
    let(:output_file) { File.join(Dir.tmpdir, "output.srt") }
    let(:entity) { described_class.new output_file }

    context "with backup" do
      subject { entity.convert_srt output_file }
      before do
        FileUtils.cp subtitle_file, output_file
      end
      it do
        expect(entity).to receive(:backup_original_file).and_call_original
        expect(entity).to receive(:recalculate_number_sequence).and_call_original
        subject
        expect(File).to exist output_file
        expect(File).to exist "#{output_file}.1"
      end
    end
  end
end