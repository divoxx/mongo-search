require 'spec_helper'

describe 'Or Matcher' do

  let(:matcher1) { mock('m1') }
  let(:matcher2) { mock('m2') }
  let(:matchers) do
      [
        {:match => matcher1, :attr => 'attribute'},
        {:match => matcher2, :attr => 'attribute'}
      ]
  end

  subject { MongoSearch::Matchers::OrMatcher.new(matchers) }

  let(:params) do
    { 'attribute' => 'value' }
  end

  context 'initialized with a pair of matchers' do
    it 'create matcher instances' do
      matcher1.should_receive(:new).with('attribute')
      matcher2.should_receive(:new).with('attribute')
      subject
    end

    context 'when the input params has values for the given keys' do
      it 'creates an $or key with an array of given matchers results' do
        matcher1.should_receive(:new).with('attribute').and_return(matcher1)
        matcher2.should_receive(:new).with('attribute').and_return(matcher2)

        matcher1.should_receive(:call).with(params).and_return('expression1')
        matcher2.should_receive(:call).with(params).and_return('expression2')

        clause = subject.call(params)

        clause[:$or].should == ['expression1', 'expression2']
      end
    end

    context 'when the input params does not have the given keys' do
      let(:matchers) do
        [
          {:match => matcher1, :attr => 'unknown_attribute'},
          {:match => matcher2, :attr => 'unknown_attribute'}
        ]
      end

      it 'creates an $or key with an array of given matchers results' do
        matcher1.should_receive(:new).with('unknown_attribute').and_return(matcher1)
        matcher2.should_receive(:new).with('unknown_attribute').and_return(matcher2)
        matcher1.should_receive(:call).with(params).and_return({})
        matcher2.should_receive(:call).with(params).and_return({})

        clause = subject.call(params)
        clause.should == {}
      end
    end
  end
end

