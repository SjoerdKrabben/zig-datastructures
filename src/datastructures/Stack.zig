const std = @import("std");
const dll = @import("DoublyLinkedList.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn Stack(comptime T: type) type {
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

        pub fn push(self: *Self, new_item: T) Allocator.Error!void {
            const new_node = try self.allocator.create(L.Node);
            new_node.* = L.Node{ .data = new_item };

            self.list.append(new_node);
        }

        pub fn pop(self: *Self) !T {
            const node = self.list.pop() orelse return error.StackUnderflow;
            const data = node.data;
            self.allocator.destroy(node);

            return data;
        }

        pub fn top(self: *Self) ?T {
            return if (self.list.last) |node| node.data else null;
        }

        pub fn isEmpty(self: *Self) bool {
            return self.list.len == 0;
        }

        pub fn size(self: *Self) usize {
            return self.list.len;
        }
    };
}

test "stack operations" {
    const allocator = std.heap.page_allocator;

    var stack = Stack(u16).init(allocator);
    defer stack.deinit();

    try stack.push(10);
    try stack.push(20);
    try stack.push(30);

    try testing.expect(stack.size() == 3);
    try testing.expect(stack.top() == 30);

    try testing.expect(try stack.pop() == 30);
    try testing.expect(stack.size() == 2);

    try testing.expect(try stack.pop() == 20);
    try testing.expect(try stack.pop() == 10);

    try testing.expect(stack.isEmpty());
}
