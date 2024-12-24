const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn HashTable(comptime T: type) type {
    return struct {
        const Self = @This();

        const Entry = struct {
            key: ?[]const u8,
            value: ?T,
        };

        allocator: Allocator,
        capacity: usize,
        table: []Entry,

        pub fn init(allocator: Allocator, capacity: usize) Allocator.Error!Self {
            const table = try allocator.alloc(Entry, capacity);

            for (table) |*entry| {
                entry.* = Entry{ .key = null, .value = null };
            }

            return Self{ .table = table, .capacity = capacity, .allocator = allocator };
        }

        pub fn deinit(self: Self) void {
            self.allocator.free(self.table);
        }

        pub fn insert(self: *Self, key: []const u8, value: T) !void {
            var index = getHash(key) % self.capacity;
            var probes: usize = 0;

            while (true) {
                const entry = &self.table[index];

                if (entry.key == null) {
                    entry.* = Entry{ .key = key, .value = value };
                } else if (std.mem.eql(u8, entry.key.?, key)) {
                    entry.value = value;
                    return;
                } else {
                    probes += 1;
                    if (probes >= self.capacity) {
                        return error.HashTableIsFull;
                    }

                    index = nextIndex(self, index);
                }
            }
        }

        pub fn get(self: *Self, key: []const u8) !?T {
            var index = getHash(key) % self.capacity;
            var probes: usize = 0;

            while (true) {
                const entry = &self.table[index];

                if (entry.key == null) {
                    return error.HashTableEntryNotFound;
                }

                if (std.mem.eql(u8, entry.key.?, key)) {
                    return entry.value;
                } else {
                    probes += 1;
                    if (probes >= self.capacity) {
                        return error.HashTableEntryNotFound;
                    }

                    index = nextIndex(self, index);
                }
            }
        }

        pub fn delete(self: *Self, key: []const u8) !void {
            var index = getHash(key) % self.capacity;
            var probes: usize = 0;

            while (true) {
                const entry = &self.table[index];
                if (std.mem.eql(u8, entry.key.?, key)) {
                    entry.key = null;
                    return;
                } else {
                    probes += 1;
                    if (probes >= self.capacity) {
                        return error.HashTableEntryNotFound;
                    }

                    index = nextIndex(self, index);
                }
            }
        }

        pub fn update(self: *Self, key: []const u8, value: T) !void {
            try self.insert(key, value);
        }

        fn getHash(key: []const u8) usize {
            var hash: usize = 0;
            const P: usize = 31;
            for (key) |byte| {
                hash = hash * P + byte;
            }
            return hash;
        }

        fn nextIndex(self: *Self, index: usize) usize {
            return (index + 1) % self.capacity;
        }
    };
}

test "HashTable Operations" {
    const allocator = testing.allocator;

    // Maakt een HashTable met capaciteit 5
    var ht = try HashTable(u32).init(allocator, 5);
    defer ht.deinit();

    // Voegt items toe aan de tabel
    try ht.insert("key1", 10);
    try ht.insert("key2", 20);
    try ht.insert("key3", 30);

    // Controleert dat we de juiste waarden terugkrijgen
    const value1 = try ht.get("key1");
    const value2 = try ht.get("key2");
    const value3 = try ht.get("key3");

    try testing.expectEqual(value1, 10);
    try testing.expectEqual(value2, 20);
    try testing.expectEqual(value3, 30);

    // Update een bestaande sleutel
    try ht.update("key2", 25);
    const updated_value2 = try ht.get("key2");
    try testing.expectEqual(updated_value2, 25);

    // Verwijder een sleutel
    try ht.delete("key1");
    try testing.expectError(error.HashTableEntryNotFound, ht.get("key1"));

    // Voeg meer items toe om de tabel te vullen
    try ht.insert("key4", 40);
    try ht.insert("key5", 50);

    // Controleer dat de tabel vol raakt
    try ht.insert("key1", 10);
    try testing.expectError(error.HashTableIsFull, ht.insert("key6", 60));
}

test "HashTable collision handling" {
    const allocator = testing.allocator;

    // Maak een kleine HashTable om collisions te forceren
    var ht = try HashTable(u32).init(allocator, 3);
    defer ht.deinit();

    // Voeg items toe met mogelijk dezelfde hash (afhankelijk van de hashfunctie)
    try ht.insert("A", 1);
    try ht.insert("B", 2);
    try ht.insert("C", 3);

    // Controleer dat alle waarden correct worden opgeslagen
    try testing.expectEqual(try ht.get("A"), 1);
    try testing.expectEqual(try ht.get("B"), 2);
    try testing.expectEqual(try ht.get("C"), 3);

    // Verwijder een sleutel en controleer dat probing blijft werken
    try ht.delete("B");
    try testing.expectError(error.HashTableEntryNotFound, ht.get("B"));

    try testing.expectEqual(try ht.get("C"), 3);

    // Voeg een nieuwe sleutel toe (die de verwijderde plaats kan hergebruiken)
    try ht.insert("D", 4);
    try testing.expectEqual(try ht.get("D"), 4);
}

test "HashTable handles null keys and values" {
    const allocator = testing.allocator;

    // Maak een HashTable
    var ht = try HashTable(?u32).init(allocator, 3);
    defer ht.deinit();

    // Voeg een item toe met een null waarde
    try ht.insert("key1", null);

    // Controleer dat null correct wordt opgeslagen
    const value = try ht.get("key1");
    try testing.expect(value.? == null);

    // Verwijder de sleutel en controleer dat deze wordt verwijderd
    try ht.delete("key1");
    try testing.expectError(error.HashTableEntryNotFound, ht.get("key1"));
}
