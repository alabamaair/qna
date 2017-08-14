require 'rails_helper'

RSpec.describe Search do
  describe '.search' do
    let(:text){ 'Request text' }
    it 'find with all resources' do
      expect(ThinkingSphinx).to receive(:search).with(text)
      Search.find(text, 'All')
    end

    it 'return nil with other resource' do
      expect(Search.find(text, 'Other')).to be_nil
    end

    %w(Questions Answers Comments Users).each do |res|
      it "find with #{res} resource" do
        expect(ThinkingSphinx).to receive(:search).with(text, classes: [res.singularize.classify.constantize])
        Search.find(text, res)
      end
    end
  end
end
