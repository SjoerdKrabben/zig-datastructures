const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn binarySearch(haystack: []const i32, low: usize, high: usize, needle: i32) i32 {
    if (high >= low) {
        const mid: usize = low + (high - low) / 2;

        if (haystack[mid] == needle) {
            return @intCast(mid);
        } else if (haystack[mid] > needle) {
            return binarySearch(haystack, low, mid - 1, needle);
        } else {
            return binarySearch(haystack, mid + 1, high, needle);
        }
    }

    return -1;
}

test "binarySearch" {
    const array = &[_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

    try testing.expectEqual(4, binarySearch(array, 0, array.len, 5));
    try testing.expectEqual(0, binarySearch(array, 0, array.len, 1));
    try testing.expectEqual(9, binarySearch(array, 0, array.len - 1, 10));
    try testing.expectEqual(-1, binarySearch(array, 0, array.len - 1, 11));
}
