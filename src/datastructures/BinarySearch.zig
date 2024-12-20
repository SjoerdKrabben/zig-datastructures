const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn binarySearch(haystack: []u16, low: u16, high: usize, needle: u16) i16 {
    if (high >= low) {
        const mid = low + (high - low) / 2;

        if (haystack[mid] == needle) {
            return @intCast(needle);
        } else if (haystack[mid] > needle) {
            return binarySearch(haystack, low, @intCast(mid - 1), needle);
        } else {
            return binarySearch(haystack, @intCast(mid + 1), high, needle);
        }
    }

    return -1;
}
