require File.dirname(__FILE__) + '/helper'

class TestCommitStats < Test::Unit::TestCase

  def setup
    File.expects(:exist?).returns(true)
    @r = Repo.new(GRIT_REPO)

    Git.any_instance.expects(:log).returns(fixture('log'))
  end

  def test_commit_stats
    assert_equal 3, @r.commit_stats.size
  end


  # to_hash

  def test_to_hash
    expected = {
      "files"=>
        [["examples/ex_add_commit.rb", 13, 0, 13],
         ["examples/ex_index.rb", 1, 1, 2]],
       "total"=>15,
       "additions"=>14,
       "id"=>"a49b96b339c525d7fd455e0ad4f6fe7b550c9543",
       "deletions"=>1
    }

    assert_equal expected, @r.commit_stats.assoc('a49b96b339c525d7fd455e0ad4f6fe7b550c9543')[1].to_hash
  end

  def test_filename_regexp_filtering
    expected = {
      "files"=>
        [["examples/ex_add_commit.rb", 13, 0, 13]],
       "total"=>13,
       "additions"=>13,
       "id"=>"a49b96b339c525d7fd455e0ad4f6fe7b550c9543",
       "deletions"=>0
    }

    assert_equal expected, @r.commit_stats("master", 10, 0, /add_commit/).assoc('a49b96b339c525d7fd455e0ad4f6fe7b550c9543')[1].to_hash
  end


end
