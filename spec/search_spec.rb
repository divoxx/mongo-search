require "spec_helper"

describe Search do
  describe "Usage" do
    let :klass do
      mock(:collection => collection)
    end

    let :collection do
      mock(:collection)
    end

    subject do
      Search.new do |c|
        c.match :name
        c.exact :status
        c.intersect :tags
        c.greater_than :updated_since, :field => :updated_at, :type => :time
        c.sort_with :order, :default => "name asc"
      end
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

    it "matches a parameters against a time span between a field and now " do
      time = Time.parse("2012-01-10T22:10:01Z")
      c, _ = subject.criteria_for :updated_since => time.strftime("%Y-%m-%dT%H:%M:%SZ")
      c.should == {:updated_at => {:$gte => time}}
    end

    it "uses specified sorting and includes a _ordenacao prefix also" do
      _, s = subject.criteria_for :order => "titulo desc"
      s.should == [[:titulo_ordenacao, :desc], [:titulo, :desc]]
    end

    it "defaults sorting direction to asc if not specified" do
      _, s = subject.criteria_for :order => "titulo, categoria"
      s.should include([:titulo, :asc])
      s.should include([:categoria, :asc])
    end

    it "uses default sorting if no specified" do
      _, s = subject.criteria_for({})
      s.should == [[:name_ordenacao, :asc], [:name, :asc]]
    end
  end
end
