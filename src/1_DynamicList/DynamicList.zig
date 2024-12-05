const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn DynamicList(comptime T: type) type {
    return struct {
        const Self = @This();

        items: []T,
        capacity: usize,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Allocator.Error!Self {
            return Self{ .items = &[_]T{}, .capacity = 0, .allocator = allocator };
        }

        pub fn deinit(self: Self) void {
            if (@sizeOf(T) > 0) {
                self.allocator.free(self.items.ptr[0..self.capacity]);
            }
        }

        pub fn size(self: *Self) usize {
            return self.items.len;
        }

        pub fn add(self: *Self, item: T) Allocator.Error!void {
            const new_capacity = self.capacity + 1;
            const new_len = self.items.len + 1;

            const new_items = try self.allocator.alloc(T, new_capacity);

            @memcpy(new_items[0..self.items.len], self.items);

            if (self.capacity > 0) {
                self.allocator.free(self.items);
            }

            self.items = new_items;
            self.capacity = new_capacity;
            self.items[new_len - 1] = item;
        }

        pub fn remove(self: *Self, position: u8) Allocator.Error!void {
            if (position >= self.items.len) {
                @panic("Index out of bounds");
            }

            var i: usize = position;
            while (i < self.items.len - 1) : (i += 1) {
                self.items[i] = self.items[i + 1];
            }

            self.items = self.items[0 .. self.items.len - 1];
        }

        pub fn contains(self: *Self, item: T) bool {
            for (self.items) |list_item| {
                if (std.meta.eql(list_item, item)) {
                    return true;
                }
            }
            return false;
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

        print("The size of this list is: {} and position {} and value: {} \n", .{ list.size(), i, list.get(i) });
    }

    list.set(5, 3);
    list.set(7, 88);
    try list.remove(4);
    try list.remove(1);

    for (0..list.size()) |i| {
        print("The size of this list is: {} and position {} and value: {} \n", .{ list.size(), i, list.get(i) });
    }

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

    print("{}\n", .{list.contains(jan)});
    print("{}\n", .{list.contains(pietje)});
    print("{}\n", .{list.contains(pieter)});
}

test "addJsonFileToDynamicList" {}
