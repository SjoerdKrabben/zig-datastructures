const std = @import("std");
const dll = @import("DoublyLinkedList.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn Deque(comptime T: type) type {
    return struct {
        const Self = @This();

        const L = dll.DoublyLinkedList(T);

        list: L,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            return Self{ .list = L{}, .allocator = allocator };
        }

        pub fn deinit(self: *Self) void {
            var it = self.list.first;
            while (it) |node| {
                const next = node.next;
                self.allocator.destroy(node);
                it = next;
            }
            self.list.first = null;
            self.list.last = null;
            self.list.len = 0;
        }

        pub fn insertLeft(self: *Self, new_item: T) Allocator.Error!void {
            const node = try self.allocator.create(L.Node);
            node.* = L.Node{ .data = new_item };

            self.list.prepend(node);
        }

        pub fn insertRight(self: *Self, new_item: T) Allocator.Error!void {
            const node = try self.allocator.create(L.Node);
            node.* = L.Node{ .data = new_item };

            self.list.append(node);
        }

        pub fn deleteLeft(self: *Self) !T {
            const node = self.list.popFirst();
            if (node) |current_node| {
                const data = current_node.data;
                self.allocator.destroy(current_node);

                return data;
            } else {
                return error.EmptyQueue;
            }
        }

        pub fn deleteRight(self: *Self) !T {
            const node = self.list.pop();
            if (node) |current_node| {
                const data = current_node.data;
                self.allocator.destroy(current_node);

                return data;
            } else {
                return error.EmptyQueue;
            }
        }

        pub fn isEmpty(self: *const Self) bool {
            return self.list.len == 0;
        }

        pub fn size(self: *const Self) usize {
            return self.list.len;
        }
    };
}

test "deque operations" {
    const allocator = testing.allocator;

    var deque = Deque(u8).init(allocator);
    defer deque.deinit();

    // Insert elements
    try deque.insertLeft(1); // {1}
    try deque.insertRight(2); // {1, 2}
    try deque.insertLeft(0); // {0, 1, 2}
    try deque.insertRight(3); // {0, 1, 2, 3}

    try testing.expect(deque.size() == 4);
    try testing.expect(!deque.isEmpty());

    // Delete elements
    try testing.expect(try deque.deleteLeft() == 0); // {1, 2, 3}
    try testing.expect(try deque.deleteRight() == 3); // {1, 2}

    try testing.expect(deque.size() == 2);

    // Test error handling
    _ = try deque.deleteLeft();
    _ = try deque.deleteLeft();
    try testing.expect(deque.isEmpty());
}
