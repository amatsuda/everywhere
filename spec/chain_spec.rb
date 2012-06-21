require 'spec_helper'
require 'everywhere/chain'

describe 'normal query' do
  before do
    @where = Post.where(:title => 'hello').where_values
  end
  specify { @where.should have(1).item }
  subject { @where.first }
  its(:to_sql) { should == %q["posts"."title" = 'hello'] }
end

describe 'not' do
  describe 'not eq' do
    before do
      @where = Post.where.not(:title => 'hello').where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" != 'hello'] }
  end

  describe 'not null' do
    before do
      @where = Post.where.not(:created_at => nil).where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."created_at" IS NOT NULL] }
  end

  describe 'not in' do
    before do
      @where = Post.where.not(:title => %w[hello goodbye]).where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT IN ('hello', 'goodbye')] }
  end

  describe 'association' do
    before do
      @where = Post.joins(:comments).where.not(:comments => {:body => 'foo'}).where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["comments"."body" != 'foo'] }
  end

  describe 'with preceding where' do
    before do
      @where = Post.where(:title => 'hello').where.not(:title => 'world').where_values
    end
    specify { @where.should have(2).items }
    it 'should work' do
      @where.last.to_sql.should == %q["posts"."title" != 'world']
    end
    describe 'preceding where' do
      it 'should not be affected' do
        @where.first.to_sql.should == %q["posts"."title" = 'hello']
      end
    end
  end

  describe 'with succeeding where' do
    before do
      @where = Post.where.not(:title => 'hello').where(:title => 'world').where_values
    end
    specify { @where.should have(2).items }
    it 'should work' do
      @where.first.to_sql.should == %q["posts"."title" != 'hello']
    end
    describe 'succeeding where' do
      it 'should not be affected' do
        @where.last.to_sql.should == %q["posts"."title" = 'world']
      end
    end
  end
end

describe 'like' do
  describe 'like match' do
    before do
      @where = Post.where.like(:title => 'he%').where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" LIKE 'he%'] }
  end
end

describe 'not like' do
  describe 'not like match' do
    before do
      @where = Post.where.not_like(:title => 'he%').where_values
    end
    specify { @where.should have(1).item }
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" NOT LIKE 'he%'] }
  end
end

describe 'chaining multiple extended queries' do
  before do
    @where = Post.where.like(:title => '%hell%').where.not(:title => 'world').where.not_like(:title => 'heaven and %').where_values
  end
  specify { @where.should have(3).items }
  describe 'not' do
    subject { @where[1] }
    its(:to_sql) { should == %q["posts"."title" != 'world'] }
  end
  describe 'like' do
    subject { @where.first }
    its(:to_sql) { should == %q["posts"."title" LIKE '%hell%'] }
  end
  describe 'not like' do
    subject { @where.last }
    its(:to_sql) { should == %q["posts"."title" NOT LIKE 'heaven and %'] }
  end
end
