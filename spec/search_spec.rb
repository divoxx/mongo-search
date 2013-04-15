require "spec_helper"

describe "Search integration" do
  let :klass do
    mock(:collection => collection)
  end

  let :collection do
    mock(:collection)
  end

  subject do
    MongoSearch::Definition.new do |c|
      c.match :name
      c.exact :status
      c.intersect :tags
      c.less_than :updated_before, :field => :updated_at, :type => :time, :equal => true
      c.greater_than :updated_since, :field => :updated_at, :type => :time, :equal => true
      c.sort_with :order, :default => "name asc", :mappings => {:titulo => :titulo_ordenacao}
      c.or :matchers => [c.match(:nome), c.intersect(:tags)]
    end
  end

  it "accepts an $or clause" do
    debugger
    c, _ = subject.criteria_for :nome => 'um titulo', :tags => 'um tags'
    c.should == {
      :$or => [
        { :nome => 'um titulo' },
        { :tags => { :$all => ['um tags'] } }
      ]
    }
  end

  it "matches partial string with case-insensitive regexp" do
    c, _ = subject.criteria_for :name => "foo"
    c.should == {:name => /foo/i}
  end

  it "matches exact string" do
    c, _ = subject.criteria_for :status => 'published'
    c.should == {:status => 'published'}
  end

  it "matches intersection of list items" do
    c, _ = subject.criteria_for :tags => ['foo', 'bar']
    c.should == {:tags => {:$all => ['foo', 'bar']}}
  end

  it "matches intersection of comma separate string" do
    c, _ = subject.criteria_for :tags => "foo,bar"
    c.should == {:tags => {:$all => ['foo', 'bar']}}
  end

  it "matches a parameter against a field using greater than op" do
    time = Time.parse("2012-01-10T22:10:01Z")
    c, _ = subject.criteria_for :updated_since => time.strftime("%Y-%m-%dT%H:%M:%SZ")
    c.should == {:updated_at => {:$gte => time}}
  end

  it "matches a parameter against a field using less than op" do
    time = Time.parse("2012-01-10T22:10:01Z")
    c, _ = subject.criteria_for :updated_before => time.strftime("%Y-%m-%dT%H:%M:%SZ")
    c.should == {:updated_at => {:$lte => time}}
  end

  it "uses specified sorting respecting custom mappings" do
    _, s = subject.criteria_for :order => "titulo desc"
    s.should == [[:titulo_ordenacao, :desc]]
  end

  it "combine sortings properly" do
    _, s = subject.criteria_for :order => "titulo, categoria"
    s.should == [[:titulo_ordenacao, :asc], [:categoria, :asc]]
  end

  it "uses default sorting if no specified" do
    _, s = subject.criteria_for({})
    s.should == [[:name, :asc]]
  end
end
