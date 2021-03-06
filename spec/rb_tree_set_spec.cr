require "./spec_helper"

def setup_rbtree_set
  tree = RBTreeSet(Int32).new
  num_items = 25
  random_array = Array.new(num_items) { rand(num_items) }
  random_array.each { |x| tree.push x }
  {tree, random_array}
end

describe "RBTreeSet" do
  describe "(empty)" do
    it "should let you push stuff in" do
      tree = RBTreeSet(Int32).new
      100.times { |x| tree << x }
      tree.size.should eq(100)
    end

    it "should be empty?" do
      tree = RBTreeSet(Int32).new
      tree.empty?.should be_true
    end

    it "should return 0 for height" do
      tree = RBTreeSet(Int32).new
      tree.height.should eq(0)
    end

    it "should return 0 for size" do
      tree = RBTreeSet(Int32).new
      tree.size.should eq(0)
    end

    it "should return nil for max and min" do
      tree = RBTreeSet(Int32).new
      tree.min_key.should be_nil
      tree.max_key.should be_nil
    end

    it "should not delete" do
      tree = RBTreeSet(Int32).new
      tree.delete(1).should be_nil
    end
  end

  describe "(non-empty)" do
    it "should return correct size (uniqify items first)" do
      tree, random_array = setup_rbtree_set()

      tree.empty?.should be_false
      tree.size.should eq(random_array.uniq!.size)
    end

    it "should return correct max and min" do
      tree, random_array = setup_rbtree_set()

      tree.min_key.should eq(random_array.min)
      tree.max_key.should eq(random_array.max)
    end

    it "should not #has_key? keys it doesn't have" do
      tree, random_array = setup_rbtree_set()

      tree.has_key?(100000).should be_false
    end

    it "should #has_key? keys it does have" do
      tree, random_array = setup_rbtree_set()

      tree.has_key?(random_array[0]).should be_true
    end

    it "should remove all keys" do
      tree, random_array = setup_rbtree_set()
      random_array.uniq!.each do |key|
        tree.has_key?(key).should eq(true)
        tree.delete(key)
        tree.has_key?(key).should eq(false)
      end
      tree.empty?.should be_true
    end

    it "should delete_min keys correctly" do
      tree, random_array = setup_rbtree_set()

      random_array = random_array.uniq!.sort!.reverse
      until tree.empty?
        key = random_array.pop
        tree.has_key?(key).should eq(true)
        tree.delete_min
        tree.has_key?(key).should eq(false)
      end
    end

    it "should delete_max keys correctly" do
      tree, random_array = setup_rbtree_set()

      random_array.uniq!.sort!
      until tree.empty?
        key = random_array.pop
        tree.has_key?(key).should eq(true)
        tree.delete_max
        tree.has_key?(key).should eq(false)
      end
    end

    it "should let you iterate with #each" do
      tree, random_array = setup_rbtree_set()

      i = 0
      random_array.uniq!.sort!
      tree.each do |key|
        key.should eq(random_array[i])
        i += 1
      end
    end

    it "should let you iterate with #reverse_each" do
      tree, random_array = setup_rbtree_set()

      i = 0
      random_array.uniq!.sort!.reverse!
      tree.reverse_each do |key|
        key.should eq(random_array[i])
        i += 1
      end
    end
  end
end
