const std = @import("std");
const dll = @import("DoublyLinkedList.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn BinaryTree(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct { left: *?Node = null, right: *?Node = null, data: T };

        currentNode: *?Node = null,
        left: *?Node = null,
        right: *?Node = null,
        len: usize = 0,

        // Pre-order:   current > left > right
        // Post-order:  left > right > current
        // in-order:    left > current > right

        pub fn find(self: *Self, needle: *Node) !Node {
            if(needle.data < self.data) {
                self.currentNode = self.left;
                self.find(needle);
            }
            if(needle.data > self.data) {
                self.currentNode = self.right;
                self.find(needle);
            }

            return self.currentNode;            
        }

        pub fn findMin(self: *Self) Node {
            while(self.left) {
                self.currentNode = self.left;
            }
            return self.currentNode;
        }

        pub fn findMax(self: *Self) Node {
            while(self.right) {
                self.currentNode = self.right;
            }
            return self.currentNode;
        }

        pub fn insert(self: *Self, new_node: *Node) !void {
           if (new_node.data < self.data) {
                if(self.left != null) {
                    self.currentNode = self.left;
                    self.insert(new_node);
                }else {
                    self.left = new_node;
                }
           }

           if (new_node.data > self.data) {
               if(self.right != null) {
                   self.currentNode = self.right;
                   self.insert(new_node);
               } else {
                   self.right = new_node;
               }
           }
        }

        pub fn remove(self: *Self, node: *Node) !void {
            
        }
    };
}
