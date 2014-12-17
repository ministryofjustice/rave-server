require 'rails_helper'

RSpec.describe ScansController, :type => :controller do
  describe 'POST /scans' do
    it 'raises an error when file or file_url is not provided' do
      expect { post :create }.to raise_error
    end

    context 'with file' do
      context 'safe file' do
        it 'returns the true or false based on whether a virus is detected' do
          params = { file: Rails.root.join('spec', 'support', 'fixtures', 'safe_file.txt') }
          post :create, params

          expect(response.status).to eq(200)
          expect(response.body).to eq('true')
        end
      end

      context 'unsafe file' do
        it 'returns the true or false based on whether a virus is detected' do
          params = { file: Rails.root.join('spec', 'support', 'fixtures', 'eicar_test_file.txt') }
          post :create, params

          expect(response.status).to eq(200)
          expect(response.body).to eq('false')
        end
      end
    end
  end
end
