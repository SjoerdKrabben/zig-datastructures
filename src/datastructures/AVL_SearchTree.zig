const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn AVLTree(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct { left: ?*Node, right: ?*Node, height: usize, data: T };

        root: ?*Node,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            return Self{
                .root = null,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            _ = self.deinitAt(self.root);
        }

        fn deinitAt(self: *Self, node: ?*Node) void {
            const current_node = node orelse return;
            std.debug.print("Deinit node: {}\n", .{current_node.data});

            if (current_node.left != null) {
                self.deinitAt(current_node.left);
            }
            if (current_node.right != null) {
                self.deinitAt(current_node.right);
            }

            self.allocator.destroy(current_node);
        }

        pub fn find(self: *Self, needle: T) ?*Node {
            return self.findAt(self.root, needle);
        }

        fn findAt(self: *Self, node: ?*Node, needle: T) ?*Node {
            const current_node = node orelse return null;

            if (needle < current_node.data) {
                return self.findAt(current_node.left, needle);
            }
            if (needle > current_node.data) {
                return self.findAt(current_node.right, needle);
            }

            return current_node;
        }

        pub fn findMin(self: *Self) ?*Node {
            return self.findMinAt(self.root);
        }

        fn findMinAt(self: *Self, node: ?*Node) ?*Node {
            const current_node = node orelse return null;

            if (current_node.left == null) {
                return current_node;
            }

            return self.findMinAt(current_node.left);
        }

        pub fn findMax(self: *Self) ?*Node {
            return self.findMaxAt(self.root);
        }

        fn findMaxAt(self: *Self, node: ?*Node) ?*Node {
            const current_node = node orelse return null;

            if (current_node.right == null) {
                return current_node;
            }

            return self.findMaxAt(current_node.right);
        }

        pub fn remove(self: *Self, data: T) void {
            _ = self.removeAt(self.root, data);
        }

        fn removeAt(self: *Self, node: ?*Node, data: T) ?*Node {
            const current_node = node orelse return null;

            if (data < current_node.data) {
                current_node.left = self.removeAt(current_node.left, data);
                return current_node;
            } else if (data > current_node.data) {
                current_node.right = self.removeAt(current_node.right, data);
                return current_node;
            } else {
                if (current_node.left == null and current_node.right == null) {
                    self.allocator.destroy(current_node);
                    return null;
                } else if (current_node.left == null) {
                    const right_node = current_node.right;
                    self.allocator.destroy(current_node);
                    return right_node;
                } else if (current_node.right == null) {
                    const left_node = current_node.left;
                    self.allocator.destroy(current_node);
                    return left_node;
                } else {
                    const successor = self.findMinAt(current_node.right);

                    if (successor) |succ| {
                        current_node.data = succ.data;
                        current_node.right = self.removeAt(current_node.right, succ.data);
                    }

                    return current_node;
                }
            }
        }

        pub fn insert(self: *Self, data: T) !void {
            const new_node = try self.allocator.create(Node);
            new_node.* = Node{
                .left = null,
                .right = null,
                .height = 0,
                .data = data,
            };

            if (self.root == null) {
                self.root = new_node;
            } else {
                self.root = self.insertAt(self.root.?, new_node);
            }
        }

        fn insertAt(self: *Self, current_node: *Node, new_node: *Node) *Node {
            if (new_node.data < current_node.data) {
                if (current_node.left) |left_node| {
                    current_node.left = self.insertAt(left_node, new_node);
                } else {
                    current_node.left = new_node;
                    new_node.height = current_node.height + 1;
                }
            }

            if (new_node.data > current_node.data) {
                if (current_node.right) |right_node| {
                    current_node.right = self.insertAt(right_node, new_node);
                } else {
                    current_node.right = new_node;
                    new_node.height = current_node.height + 1;
                }
            }

            return balance(current_node);
        }

        fn balance(node: *Node) *Node {
            const balance_factor: isize = getBalanceFactor(node);

            if (balance_factor > 1) {
                if (getBalanceFactor(node.left) < 0) {
                    node.left = rotateLeft(node.left.?);
                }

                return rotateRight(node);
            } else if (balance_factor < -1) {
                if (getBalanceFactor(node.right) > 0) {
                    node.right = rotateRight(node.right.?);
                }

                return rotateLeft(node);
            }
            return node;
        }

        fn getBalanceFactor(node: ?*Node) isize {
            if (node) |n| {
                return @as(isize, @intCast(getHeight(n.left))) - @as(isize, @intCast(getHeight(n.right)));
            } else {
                return 0;
            }
        }

        fn rotateRight(node: *Node) *Node {
            const new_root = node.left orelse return node;

            node.left = new_root.right;
            new_root.right = node;

            updateHeight(node);
            updateHeight(new_root);

            return new_root;
        }

        fn rotateLeft(node: *Node) *Node {
            const new_root = node.right orelse return node;

            node.right = new_root.left;
            new_root.left = node;

            updateHeight(node);
            updateHeight(new_root);

            return new_root;
        }

        fn updateHeight(node: *Node) void {
            node.height = (@max(getHeight(node.left), getHeight(node.right)) + 1);
        }

        fn getHeight(node: ?*Node) usize {
            if (node) |n| {
                return n.height;
            } else {
                return 0;
            }
        }
    };
}

test "AVL-Tree operations" {
    const allocator = std.testing.allocator;
    var tree = AVLTree(i32).init(allocator);
    defer tree.deinit();

    // Test: Insert elements
    try tree.insert(50);
    try tree.insert(30);
    try tree.insert(70);
    try tree.insert(20);
    try tree.insert(40);
    try tree.insert(60);
    try tree.insert(80);

    // Verify the structure by finding elements
    try std.testing.expect(tree.find(50) != null);
    try std.testing.expect(tree.find(30) != null);
    try std.testing.expect(tree.find(70) != null);
    try std.testing.expect(tree.find(20) != null);
    try std.testing.expect(tree.find(40) != null);
    try std.testing.expect(tree.find(60) != null);
    try std.testing.expect(tree.find(80) != null);
    try std.testing.expect(tree.find(100) == null); // Non-existent element

    // Test: Find minimum and maximum
    const min = tree.findMin();
    try std.testing.expect(min != null);
    try std.testing.expect(min.?.data == 20);

    const max = tree.findMax();
    try std.testing.expect(max != null);
    try std.testing.expect(max.?.data == 80);

    // Test: Remove leaf node
    tree.remove(20);
    try std.testing.expect(tree.find(20) == null);

    // Test: Remove node with one child
    tree.remove(30);
    try std.testing.expect(tree.find(30) == null);
    try std.testing.expect(tree.find(40) != null); // Verify child node remains

    // Test: Remove node with two children
    tree.remove(50);
    try std.testing.expect(tree.find(50) == null);
    try std.testing.expect(tree.find(60) != null); // Successor becomes root
    try std.testing.expect(tree.find(70) != null); // Verify structure remains intact

}

test "AVLTree balance test" {
    const allocator = std.testing.allocator;
    var avl_tree = AVLTree(i32).init(allocator);

    defer avl_tree.deinit();

    // Data om in te voegen
    const test_data = [_]i32{ 10, 20, 30, 40, 50, 25 };

    // Voeg data toe aan de AVL-boom
    for (test_data) |value| {
        try avl_tree.insert(value);
    }

    // Controleer of de AVL-boom correct gebalanceerd is
    try testing_checkBalance(avl_tree.root);

    // Controleer de in-order traversal (moet gesorteerd zijn)
    const sorted_data = try testing_getSortedData(avl_tree.root);
    defer allocator.free(sorted_data);
    assert(std.mem.eql(i32, sorted_data, &[_]i32{ 10, 20, 25, 30, 40, 50 }));
}

fn testing_checkBalance(node: ?*AVLTree(i32).Node) !void {
    if (node) |n| {
        const balance_factor = @as(isize, @intCast(testing_getHeight(n.left))) - @as(isize, @intCast(testing_getHeight(n.right)));
        assert(balance_factor >= -1 and balance_factor <= 1);

        // Controleer recursief de balans van kinderen
        try testing_checkBalance(n.left);
        try testing_checkBalance(n.right);
    }
}

fn testing_getHeight(node: ?*AVLTree(i32).Node) usize {
    if (node) |n| {
        return n.height;
    }
    return 0;
}

fn testing_getSortedData(node: ?*AVLTree(i32).Node) ![]i32 {
    const allocator = testing.allocator;

    if (node == null) {
        return try allocator.alloc(i32, 0);
    }

    const left_data = try testing_getSortedData(node.?.left);
    const right_data = try testing_getSortedData(node.?.right);

    var result = try allocator.alloc(i32, left_data.len + 1 + right_data.len);
    var index: usize = 0;

    // Voeg data in in-order volgorde toe
    for (left_data) |value| {
        result[index] = value;
        index += 1;
    }

    result[index] = node.?.data;
    index += 1;

    for (right_data) |value| {
        result[index] = value;
        index += 1;
    }

    allocator.free(left_data);
    allocator.free(right_data);

    return result;
}
