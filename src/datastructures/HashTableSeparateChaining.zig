const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn HashTableSeparateChaining(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            key: []const u8,
            value: T,
            next: ?*Node = null,
            prev: ?*Node = null,
        };

        const Bucket = struct {
            const InnerSelf = @This();

            first: ?*Node = null,
            last: ?*Node = null,
            len: usize = 0,

            pub fn insertAfter(list: *InnerSelf, node: *Node, new_node: *Node) void {
                new_node.prev = node;

                if (node.next) |next_node| {
                    new_node.next = next_node;
                    next_node.prev = new_node;
                } else {
                    new_node.next = null;
                    list.last = new_node;
                }
                node.next = new_node;

                list.len += 1;
            }

            pub fn insertBefore(list: *InnerSelf, node: *Node, new_node: *Node) void {
                new_node.next = node;

                if (node.prev) |prev_node| {
                    new_node.prev = prev_node;
                    prev_node.next = new_node;
                } else {
                    new_node.prev = null;
                    list.first = new_node;
                }
                node.prev = new_node;

                list.len += 1;
            }

            pub fn append(list: *InnerSelf, new_node: *Node) void {
                if (list.last) |last| {
                    list.insertAfter(last, new_node);
                } else {
                    list.prepend(new_node);
                }
            }

            pub fn prepend(list: *InnerSelf, new_node: *Node) void {
                if (list.first) |first| {
                    list.insertBefore(first, new_node);
                } else {
                    list.first = new_node;
                    list.last = new_node;
                    new_node.prev = null;
                    new_node.next = null;

                    list.len += 1;
                }
            }

            pub fn remove(list: *InnerSelf, node: *Node) void {
                if (node.prev) |prev_node| {
                    prev_node.next = node.next;
                } else {
                    list.first = node.next;
                }

                if (node.next) |next_node| {
                    next_node.prev = node.prev;
                } else {
                    list.last = node.prev;
                }

                list.len -= 1;
            }

            pub fn pop(list: *InnerSelf) ?*Node {
                const last = list.last orelse return null;
                list.remove(last);
                return last;
            }

            pub fn popFirst(list: *InnerSelf) ?*Node {
                const first = list.first orelse return null;
                list.remove(first);
                return first;
            }
        };

        allocator: Allocator,
        capacity: usize,
        table: []Bucket,

        pub fn init(allocator: Allocator, capacity: usize) Allocator.Error!Self {
            const table = try allocator.alloc(Bucket, capacity);

            for (table) |*bucket| {
                bucket.* = Bucket{};
            }

            return Self{ .table = table, .capacity = capacity, .allocator = allocator };
        }

        pub fn deinit(self: Self) void {
            for (self.table) |bucket| {
                var node = bucket.first;
                while (node) |current| {
                    const next = current.next;
                    self.allocator.destroy(current);
                    node = next;
                }
            }
            self.allocator.free(self.table);
        }

        pub fn insert(self: *Self, key: []const u8, value: T) Allocator.Error!void {
            const index = getHash(key) % self.capacity;
            const bucket = &self.table[index];
            var node = bucket.first;

            while (node) |current| {
                if (std.mem.eql(u8, current.key, key)) {
                    current.value = value;
                    return;
                }
                node = current.next;
            }

            const new_node = try self.allocator.create(Node);
            new_node.* = Node{
                .key = key,
                .value = value,
                .next = null,
                .prev = null,
            };

            bucket.append(new_node);
        }

        pub fn get(self: *Self, key: []const u8) ?T {
            const index = getHash(key) % self.capacity;
            const bucket = &self.table[index];
            var node = bucket.first;

            while (node) |current| {
                if (std.mem.eql(u8, current.key, key)) {
                    return current.value;
                }
                node = current.next;
            }
            return null;
        }

        pub fn delete(self: *Self, key: []const u8) !void {
            const index = getHash(key) % self.capacity;
            const bucket = &self.table[index];
            var node = bucket.first;

            while (node) |current| {
                if (std.mem.eql(u8, current.key, key)) {
                    bucket.remove(current);
                    self.allocator.destroy(current);
                    return;
                }
                node = current.next;
            }

            return error.KeyNotFound;
        }

        pub fn clear(self: *Self) void {
            for (self.table) |bucket| {
                var node = bucket.last;
                while (node) |current| {
                    const prev = current.prev;
                    self.allocator.free(current);
                    node = prev;
                }
            }
        }

        fn getHash(key: []const u8) usize {
            var hash: usize = 0;
            const P: usize = 31;
            for (key) |byte| {
                hash = hash * P + byte;
            }
            return hash;
        }
    };
}

test "HashTableSeparateChaining operations" {
    const allocator = testing.allocator;
    const capacity = 16;

    // Initialiseer de HashTable
    var hashtable = try HashTableSeparateChaining([]const u8).init(allocator, capacity);

    defer hashtable.deinit();
    // Voeg items toe
    try hashtable.insert("key1", "value1");
    try hashtable.insert("key2", "value2");
    try hashtable.insert("key3", "value3");

    // Ophalen van items
    try testing.expectEqualStrings(hashtable.get("key1") orelse unreachable, "value1");
    try testing.expectEqualStrings(hashtable.get("key2") orelse unreachable, "value2");
    try testing.expectEqualStrings(hashtable.get("key3") orelse unreachable, "value3");

    // Controleer op een niet-bestaande key
    try testing.expect(hashtable.get("key4") == null);

    // Overschrijf een bestaande key
    try hashtable.insert("key1", "new_value1");
    try testing.expectEqualStrings(hashtable.get("key1") orelse unreachable, "new_value1");

    // Verwijder een item
    try hashtable.delete("key2");
    try testing.expect(hashtable.get("key2") == null);

    // Controleer dat andere items nog steeds aanwezig zijn
    try testing.expectEqualStrings(hashtable.get("key1") orelse unreachable, "new_value1");
    try testing.expectEqualStrings(hashtable.get("key3") orelse unreachable, "value3");
}
