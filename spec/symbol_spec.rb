require 'spec_helper'
require 'everywhere/symbol'

describe 'normal query' do
  before do
    @where = Post.where(:name => 'hello').where_values
  end
  subject { @where }
  it { @where.should have(1).item }
  subject { @where.first }
  its(:to_sql) { should == %q["posts"."name" = 'hello'] }
end

describe 'not' do
  describe 'not eq' do
    before do
      @where = Post.where(:not, :name => 'hello').where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."name" != 'hello'] }
  end

  describe 'not null' do
    before do
      @where = Post.where(:not, :created_at => nil).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."created_at" IS NOT NULL] }
  end

  describe 'not in' do
    before do
      @where = Post.where(:not, :name => %w[hello goodbye]).where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."name" NOT IN ('hello', 'goodbye')] }
  end

  describe 'association' do
    before do
      @where = Post.joins(:comments).where(:not, :comments => {:body => 'foo'}).where_values
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
      @where = Post.where(:like, :title => 'he%').where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" LIKE 'he%'] }
  end
end

describe 'not like' do
  describe 'not like match' do
    before do
      @where = Post.where(:not_like, :title => 'he%').where_values
    end
    subject { @where }
    it { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT LIKE 'he%'] }
  end
end
