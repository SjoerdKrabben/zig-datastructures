const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;

const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn KeyValuePair(comptime T: type) type {
    return struct {
        key: []const u8,
        value: T,

        pub fn init(key: []const u8, value: T) KeyValuePair(T) {
            return KeyValuePair(T){
                .key = key,
                .value = value,
            };
        }
    };
}
