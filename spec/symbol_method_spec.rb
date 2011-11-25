require 'spec_helper'
require 'everywhere/symbol_method'

describe 'Symbol#not' do
  before do
    @name = 'yalab'
    @result = {:name.not => @name}
  end
  subject{ @result }
  it { @result.should == {{:not => :name} => @name} }
end

describe 'not' do
  describe 'not eq' do
    before do
      @where = Post.where(:name.not => 'hello').where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."name" != 'hello'] }
  end

  describe 'not null' do
    before do
      @where = Post.where(:created_at.not => nil).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."created_at" IS NOT NULL] }
  end

  describe 'not in' do
    before do
      @where = Post.where(:title.not => %w[hello goodbye]).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT IN ('hello', 'goodbye')] }
  end

  describe 'association' do
    before do
      @where = Post.joins(:comments).where(:comments => {:body.not => 'foo'}).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["comments"."body" != 'foo'] }
  end
end

describe 'like' do
  describe 'like match' do
    before do
      @where = Post.where(:title.like => 'he%').where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" LIKE 'he%'] }
  end
end
