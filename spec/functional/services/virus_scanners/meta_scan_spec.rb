require 'rails_helper'

require 'virus_scanners'

describe Services::VirusScanners::MetaScan do
  describe '#is_safe?' do
    context "given a safe file" do
      let(:file){ Rails.root.join('spec', 'support', 'fixtures', 'safe_file.txt') }

      it "returns true" do
        expect(subject.is_safe?(file)).to eq(true)
      end
    end

    context "given an unsafe file" do
      let(:file){ Rails.root.join('spec', 'support', 'fixtures', 'eicar_test_file.txt') }

      it "returns false" do
        expect(subject.is_safe?(file)).to eq(false)
      end
    end
  end
end