require 'spec_helper'

describe 'Or Matcher' do

  let(:attr) { :titulo_ou_tags }
  subject { MongoSearch::Matchers::OrMatcher.new(attr) }

  context 'called for params containing the given attribute keys' do
    let(:value) { 'um titulo' }

    let(:params) do
      { attr => value }
    end

    let(:conditional) do
      {
        :$or => [
          {:titulo => 'um titulo' }, {:tags => { :$all => ['um titulo'] }}
        ]
      }
    end

    it 'builds the or conditional clause' do
      subject.call(params).should == conditional
    end
  end
end

