require 'minitest/autorun'
require 'minitest/pride'
require './lib/book'
require './lib/author'
require './lib/library'

class LibraryTest < MiniTest::Test
  def setup
    @dpl = Library.new("Denver Public Library")
    @charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    @jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    @harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    @mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

  end

  def test_attributes_are_instantiated
    assert_instance_of Library, @dpl
    assert_equal "Denver Public Library", @dpl.name
    assert_equal [], @dpl.books
    assert_equal [], @dpl.authors
  end

  def test_library_can_add_authors_and_their_books
    @professor = @charlotte_bronte.write("The Professor", "1857")
    @villette = @charlotte_bronte.write("Villette", "1853")
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    assert_equal [@charlotte_bronte, @harper_lee], @dpl.authors
    expected = [@jane_eyre, @professor, @villette, @mockingbird]
    assert_equal expected, @dpl.books
    expected = {:start=>"1847", :end=>"1857"}
    assert_equal expected, @dpl.publication_time_frame_for(@charlotte_bronte)
    expected = {:start=>"1960", :end=>"1960"}
    assert_equal expected, @dpl.publication_time_frame_for(@harper_lee)
  end

  def test_can_only_check_out_books_if_they_exist_and_are_not_checked_out
    @villette = @charlotte_bronte.write("Villette", "1853")
    assert_equal false, @dpl.checkout(@mockingbird)
    assert_equal false, @dpl.checkout(@jane_eyre)
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    assert_equal true, @dpl.checkout(@jane_eyre)
    assert_equal [@jane_eyre], @dpl.checked_out_books
    assert_equal false, @dpl.checkout(@jane_eyre)
    @dpl.return(@jane_eyre)
    assert_equal [], @dpl.checked_out_books
    assert_equal true, @dpl.checkout(@jane_eyre)
    assert_equal true, @dpl.checkout(@villette)
    assert_equal [@jane_eyre, @villette], @dpl.checked_out_books
    assert_equal true, @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    assert_equal true, @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    assert_equal true, @dpl.checkout(@mockingbird)
    assert_equal @mockingbird, @dpl.most_popular_book
  end
end