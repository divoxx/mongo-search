require 'spec_helper'

describe 'Or Matcher' do

  let(:matcher1) { mock('matcher1') } 
  let(:matcher2) { mock('matcher2') } 
  let(:matchers) { [matcher1, matcher2] }
  subject { MongoSearch::Matchers::OrMatcher.new(matchers) }

  let(:params) do
    { 'attribute' => 'value' }
  end

  context 'initialized with a pair of matchers' do
    it 'calls both matchers' do
      matcher1.should_receive(:call).with(params)
      matcher2.should_receive(:call).with(params)
      subject.call(params)
    end

    it 'creates an $or key with an array of given matchers results' do
      ret1 = stub('ret1')
      ret2 = stub('ret2')

      matcher1.should_receive(:call).with(params).and_return(ret1)
      matcher2.should_receive(:call).with(params).and_return(ret2)
      clause = subject.call(params)

      clause[:$or].should == [ret1, ret2]
    end
  end
end

