const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn DynamicList(comptime T: type) type {
    return struct {
        const Self = @This();

        items: []T,
        capacity: usize,
        length: usize,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Allocator.Error!Self {
            return Self{ .items = &[_]T{}, .capacity = 0, .length = 0, .allocator = allocator };
        }

        pub fn deinit(self: Self) void {
            if (@sizeOf(T) > 0) {
                self.allocator.free(self.items.ptr[0..self.capacity]);
            }
        }

        pub fn size(self: *Self) usize {
            return self.length;
        }

        pub fn add(self: *Self, item: T) Allocator.Error!void {
            if (self.length == self.capacity) {
                const new_capacity = if (self.capacity == 0) 1 else self.capacity * 2;
                const new_items = try self.allocator.alloc(T, new_capacity);

                if (self.length > 0) {
                    @memcpy(new_items[0..self.length], self.items);
                }

                if (self.capacity > 0) {
                    self.allocator.free(self.items);
                }

                self.items = new_items;
                self.capacity = new_capacity;
            }

            self.items[self.length] = item;
            self.length += 1;
            print("Added item: {}, new capacity: {}, new length: {}\n", .{ item, self.capacity, self.length });
        }

        pub fn remove(self: *Self, position: u8) Allocator.Error!void {
            if (position >= self.length) {
                @panic("Index out of bounds");
            }

            var i: usize = position;
            while (i < self.length - 1) : (i += 1) {
                self.items[i] = self.items[i + 1];
            }

            self.items = self.items[0 .. self.length - 1];
            self.capacity -= 1;
            self.length -= 1;
        }

        pub fn contains(self: *Self, item: T) bool {
            for (self.items) |list_item| {
                if (std.meta.eql(list_item, item)) {
                    return true;
                }
            }
            return false;
        }

        pub fn indexOf(self: *Self, item: T) isize {
            for (self.items, 0..) |list_item, i| {
                if (std.meta.eql(list_item, item)) {
                    return @intCast(i);
                }
            }
            return -1;
        }

        pub fn get(self: Self, i: usize) T {
            return self.items[i];
        }

        pub fn set(self: Self, position: u8, item: T) void {
            self.items[position] = item;
        }
    };
}

test "createListAndTestFunctionsWithNumbers" {
    const allocator = std.heap.page_allocator;
    var list = try DynamicList(i32).init(allocator);
    defer list.deinit();

    for (0..10) |i| {
        const value = 10 * @as(i32, @intCast(i));
        try list.add(value);
    }

    list.set(5, 3);
    list.set(7, 88);
    try list.remove(4);
    try list.remove(1);

    print("The list contains 88? {}\n", .{list.contains(88)});
}

test "compareStructs" {
    const allocator = std.heap.page_allocator;
    const Names = struct { id: u8, name: []const u8 };
    var list = try DynamicList(Names).init(allocator);
    defer list.deinit();

    const pietje = Names{ .id = 1, .name = "Pietje" };
    const jan = Names{ .id = 2, .name = "Jan" };
    const pieter = Names{ .id = 3, .name = "Pieter" };

    try list.add(pietje);
    try list.add(jan);

    print("list constains jan: {}\n", .{list.contains(jan)});
    print("list contains pietje: {}\n", .{list.contains(pietje)});
    print("list contains pieter: {}\n", .{list.contains(pieter)});
}

test "DynamicList operations" {
    const allocator = std.heap.page_allocator;

    var list = try DynamicList(i32).init(allocator);

    defer list.deinit();

    try list.add(10);
    try list.add(20);
    try list.add(30);

    try testing.expect(list.length == 3);
    try testing.expect(list.capacity >= list.length);

    try testing.expect(list.get(0) == 10);
    try testing.expect(list.get(1) == 20);
    try testing.expect(list.get(2) == 30);

    try list.remove(1);
    try testing.expect(list.length == 2);
    try testing.expect(list.get(0) == 10);
    try testing.expect(list.get(1) == 30);

    try testing.expect(list.contains(10));
    try testing.expect(!list.contains(20));
    try testing.expect(list.contains(30));

    try testing.expect(list.indexOf(10) == 0);
    try testing.expect(list.indexOf(30) == 1);
    try testing.expect(list.indexOf(20) == -1);

    list.set(1, 40);
    try testing.expect(list.get(1) == 40);
}
