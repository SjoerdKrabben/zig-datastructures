const std = @import("std");
const dl = @import("DynamicList.zig");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn PriorityQueue(comptime T: type) type {
    return struct {
        const Self = @This();

        list: dl.DynamicList(T),

        pub fn init(allocator: Allocator) Allocator.Error!Self {
            return Self{ .list = try dl.DynamicList(T).init(allocator) };
        }

        pub fn deinit(self: Self) void {
            self.list.deinit();
        }

        pub fn add(self: *Self, item: T) !void {
            try self.list.add(item);
            self.runtimeSort();
        }

        fn runtimeSort(self: *Self) void {
            const slice = self.list.items[0..self.list.size()];
            std.mem.sort(T, slice, {}, std.sort.asc(T));
        }

        pub fn peek(self: *Self) !T {
            if (self.list.size() == 0) {
                return error.DynamicListEmpty;
            }
            return self.list.get(0);
        }

        pub fn poll(self: *Self) !T {
            if (self.list.size() == 0) {
                return error.DynamicListEmpty;
            }
            const prio = self.list.get(0);

            try self.list.remove(0);
            return prio;
        }
    };
}

test "PriorityQueue operations" {
    const allocator = std.heap.page_allocator;
    var queue = try PriorityQueue(i32).init(allocator);

    defer queue.deinit();

    try queue.add(10);
    try queue.add(5);
    try queue.add(20);

    // Test peek
    //assert(try queue.peek() == 20);

    // Test poll
    assert(try queue.poll() == 20);
    assert(try queue.peek() == 10);

    // Test empty queue
    _ = try queue.poll();
    _ = try queue.poll();
    try std.testing.expectError(error.EmptyQueue, queue.poll());
}
