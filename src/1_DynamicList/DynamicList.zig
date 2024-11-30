const std = @import("std");
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn DynamicList(comptime T: type) type {
    return struct {
        const Self = @This();

        items: []T,
        capacity: usize,
        allocator: *Allocator,

        pub fn init(allocator: *Allocator) Allocator.Error!Self {
            return Self{
                .items = &[_]T{},
                .capacity = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: Self) void {
            if (@sizeOf(T) > 0) {
                self.allocator.free(self.items.ptr[0..self.capacity]);
            }
        }

        pub fn size(self: Self) usize {
            return self.capacity;
        }

        pub fn add(self: *Self, item: T) Allocator.Error!void {
            const new_capacity = self.capacity + 1;
            const new_len = self.items.len + 1;

            const new_items = try self.allocator.realloc(T, new_capacity);

            if (self.capacity > 0) {
                self.allocator.free(self.items);
            }

            self.items = new_items;
            self.capacity = new_capacity;
            self.items[new_len] = item;
        }

        pub fn remove(self: Self) void {
            self.items[self.capacity + 1] = null;
            self.capacity -= 1;
        }

        pub fn contains(self: Self, item: T) bool {
            for (self.items[0..]) |it| {
                if (it == item) {
                    return true;
                }
            }
            return false;
        }

        pub fn get(self: Self, i: u8) T {
            return self.items[i];
        }

        pub fn set(self: Self, item: T, position: u8) void {
            self.items[position] = item;
        }
    };
}
