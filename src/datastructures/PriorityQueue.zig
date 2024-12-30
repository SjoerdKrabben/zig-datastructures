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
                return error.EmptyQueue;
            }
            return self.list.get(0);
        }

        pub fn poll(self: *Self) !T {
            if (self.list.size() == 0) {
                return error.EmptyQueue;
            }
            const prio = self.list.get(0);

            try self.list.remove(0);
            return prio;
        }

        pub fn size(self: *Self) usize {
            return self.list.size();
        }
    };
}

test "PriorityQueue Operations" {
    const allocator = std.testing.allocator;

    var prioque = try PriorityQueue(u16).init(allocator);
    defer prioque.deinit();

    try testing.expect(prioque.size() == 0);

    try prioque.add(10);
    try prioque.add(20);
    try prioque.add(15);

    try testing.expect(prioque.size() == 3);

    const peeked = try prioque.peek();
    try testing.expect(peeked == 10);

    const polled = try prioque.poll();
    try testing.expect(polled == 10);

    try testing.expect(prioque.size() == 2);

    const peeked_after_poll = try prioque.peek();
    try testing.expect(peeked_after_poll == 15);

    const second_polled = try prioque.poll();
    try testing.expect(second_polled == 15);

    const third_polled = try prioque.poll();
    try testing.expect(third_polled == 20);

    try testing.expect(prioque.size() == 0);

    try testing.expect(prioque.poll() catch |err| err == error.EmptyQueue);
}

test "PriorityQueue werkt met lege queue" {
    const allocator = std.testing.allocator;

    var prioque = try PriorityQueue(u16).init(allocator);
    defer prioque.deinit();

    try testing.expect(prioque.peek() catch |err| err == error.EmptyQueue);

    try testing.expect(prioque.poll() catch |err| err == error.EmptyQueue);
}
