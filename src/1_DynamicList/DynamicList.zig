const std = @import("std");

pub fn DynamicList(comptime T: type) type {
    return struct {
        allocator: *const std.mem.Allocator,
        items: []T,
        capacity: usize,

        pub fn init(allocator: *const std.mem.Allocator) !*@This() {
            const self = try allocator.create(@This());
            self.allocator = allocator;
            self.items = &[_]T{};
            self.capacity = 0;

            return self;
        }

        pub fn size(self: *@This()) usize {
            return self.capacity;
        }

        pub fn add(self: *@This(), item: T) void {
            self.capacity += 1;
            self.items[self.capacity + 1] = item;
        }

        pub fn remove(self: *@This()) void {
            self.items[self.capacity + 1] = null;
            self.capacity -= 1;
        }

        pub fn contains(self: *@This(), item: T) bool {
            for (self.items[0..]) |it| {
                if (it == item) {
                    return true;
                }
            }
            return false;
        }

        pub fn get(self: *@This(), i: u8) T {
            return self.items[i];
        }

        pub fn set(self: *@This(), item: T, position: u8) void {
            self.items[position] = item;
        }
    };
}
