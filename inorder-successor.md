### Inorder Successor

In Binary Search Tree, `Inorder Successor` of an input node can also be defined as the node with the smallest key greater than the key of input node. So, it is sometimes important to find next node in sorted order.

![BST](http://www.geeksforgeeks.org/wp-content/uploads/2009/09/BST_LCA.gif)

##### Algorithm:
1. If right subtree of node is not NULL, then succ lies in right subtree. Do following.
Go to right subtree and return the node with minimum key value in right subtree.
2. If right sbtree of node is NULL, then succ is one of the ancestors. Do following.
Travel up using the parent pointer until you see a node which is left child of it’s parent. The parent of such a node is the succ.
