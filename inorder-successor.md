### Inorder Successor

In Binary Search Tree, `Inorder Successor` of an input node can also be defined as the node with the smallest key greater than the key of input node. So, it is sometimes important to find next node in sorted order.

![BST](http://www.geeksforgeeks.org/wp-content/uploads/2009/09/BST_LCA.gif)

##### Method 1:
1. If right subtree of node is not NULL, then succ lies in right subtree. Do following.
Go to right subtree and return the node with minimum key value in right subtree.
2. If right sbtree of node is NULL, then succ is one of the ancestors. Do following.
Travel up using the parent pointer until you see a node which is left child of it’s parent. The parent of such a node is the succ.


###### ruby implementation
```ruby
module BST
  Node = Struct.new(:value, :parent, :left, :right)

  # Finds the 'next' node (in-order successor) of a given node in a binary search tree,
  # see examples in test/bst_test.rb
  def self.find_next(node)
    return nil if node.nil?

    # find the left most node in the right subtree
    if node.right
      n = node.right
      n = n.left while n.left
      return n
    end

    # otherwise go up until we're on the left side
    n = node
    p = n.parent
    while p && p.left != n
      n = p
      p = p.parent
    end

    p
  end
end
```
