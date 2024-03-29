require File.dirname(__FILE__) + '/../test_helper'

class ArticleDropWithRootTest < ActiveSupport::TestCase
  fixtures :sites, :sections, :contents, :assigned_sections, :users, :tags, :taggings, :assigned_assets, :assets

  def setup
    @context = mock_context('site' => sites(:first).to_liquid)
    @article = contents(:welcome).to_liquid(:mode => :single)
    @article.context = @context
    Mephisto::Liquid::UrlMethods.stubs(:relative_url_root).returns(root)
  end
  def root() '' end
  def test_should_show_article_url
    t = Time.now.utc - 3.days
    assert_equal "#{root}/#{t.year}/#{t.month}/#{t.day}/welcome-to-mephisto", @article.url
  end

  def test_should_show_comments_feed_url
    t = Time.now.utc - 3.days
    assert_equal "#{root}/#{t.year}/#{t.month}/#{t.day}/welcome-to-mephisto/comments.xml", @article.comments_feed_url
  end

  def test_should_change_feed_url
    t = Time.now.utc - 3.days
    assert_equal "#{root}/#{t.year}/#{t.month}/#{t.day}/welcome-to-mephisto/changes.xml", @article.changes_feed_url
  end
end

class ArticleDropWithRelativeRootTest < ArticleDropWithRootTest
  def root() '/blog' end
end

class ArticleDropTest < ActiveSupport::TestCase
  fixtures :sites, :sections, :contents, :assigned_sections, :users, :tags, :taggings, :assigned_assets, :assets
  
  def setup
    @context = mock_context('site' => sites(:first).to_liquid)
    @article = contents(:welcome).to_liquid(:mode => :single)
    @article.context = @context
  end

  def test_equality
    article = contents(:welcome).to_liquid
    assert_equal article, contents(:welcome)
    assert_equal article, contents(:welcome).to_liquid
  end

  def test_should_convert_article_to_drop
    assert_kind_of Liquid::Drop, contents(:welcome).to_liquid
  end
  
  def test_should_list_all_but_home_sections
    assert_equal [sections(:about)], @article.sections.collect(&:source)
  end
  
  def test_should_list_tags
    assert_equal %w(rails), ArticleDrop.new(contents(:another)).tags
  end
  
  def test_should_list_only_blog_sections
    sections(:home).update_attribute :path, 'foo'
    assert_equal [sections(:home)], @article.blog_sections.collect(&:source)
  end
  
  def test_should_list_only_paged_sections
    assert_equal [sections(:about)], @article.page_sections.collect(&:source)
  end

  def test_empty_body
    assert contents(:welcome).update_attributes(:body => nil, :excerpt => nil), contents(:welcome).errors.full_messages.to_sentence
    a = contents(:welcome).to_liquid
    assert !a['excerpt']
    assert_equal '', a.send(:body_for_mode, :single)
    assert_equal '', a.send(:body_for_mode, :list)
  end
  
  def test_should_use_nil_published_date_for_draft
    contents(:welcome).published_at = nil
    assert_nil contents(:welcome).to_liquid['published_at']
  end
  
  def test_body_with_excerpt
    assert contents(:welcome).update_attributes(:body => 'body', :excerpt => 'excerpt'), contents(:welcome).errors.full_messages.to_sentence
    a = contents(:welcome).to_liquid
    assert a['excerpt']
    assert_equal "<p>body</p>", a.send(:body_for_mode, :single)
    assert_equal '<p>excerpt</p>', a.send(:body_for_mode, :list)
  end
  
  def test_only_body
    assert contents(:welcome).update_attributes(:body => 'body', :excerpt => nil), contents(:welcome).errors.full_messages.to_sentence
    a = contents(:welcome).to_liquid
    assert_equal "<p>body</p>", a.send(:body_for_mode, :single)
    assert_equal '<p>body</p>', a.send(:body_for_mode, :list)
  end
  
  def test_only_body_with_empty_excerpt
    assert contents(:welcome).update_attributes(:body => 'body', :excerpt => ''), contents(:welcome).errors.full_messages.to_sentence
    a = contents(:welcome).to_liquid
    assert_equal "<p>body</p>", a.send(:body_for_mode, :single)
    assert_equal '<p>body</p>', a.send(:body_for_mode, :list)
  end

  def test_should_show_taggable_tags
    assert_equal %w(rails), contents(:another).to_liquid.tags
  end

  def test_should_find_article_assets
    assert_models_equal [assets(:gif), assets(:mp3)], @article.assets.collect(&:source)
  end
end
