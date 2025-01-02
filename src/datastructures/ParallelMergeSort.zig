const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

pub fn mergeSort(array: []i32, left: usize, right: usize) !void {
    if (left < right) {
        const mid: usize = left + (right - left) / 2;

        try mergeSort(array, left, mid);
        try mergeSort(array, mid + 1, right);

        try merge(array, left, mid, right);
    }
}

fn merge(array: []i32, left: usize, mid: usize, right: usize) Allocator.Error!void {
    const allocator: Allocator = std.heap.page_allocator;
    const n1 = mid - left + 1;
    const n2 = right - mid;

    var L: []i32 = try allocator.alloc(i32, n1);
    defer allocator.free(L);

    var R: []i32 = try allocator.alloc(i32, n2);
    defer allocator.free(R);

    for (0..n1) |i| {
        L[i] = array[left + i];
    }
    for (0..n2) |i| {
        R[i] = array[mid + 1 + i];
    }

    var i: usize = 0;
    var j: usize = 0;
    var k: usize = left;
    while (i < n1 and j < n2) {
        if (L[i] <= R[j]) {
            array[k] = L[i];
            i += 1;
        } else {
            array[k] = R[j];
            j += 1;
        }
        k += 1;
    }

    while (i < n1) {
        array[k] = L[i];
        i += 1;
        k += 1;
    }

    while (j < n2) {
        array[k] = R[j];
        j += 1;
        k += 1;
    }
}

test "MergeSort werkt correct met een gesorteerde array" {
    var array: [5]i32 = [_]i32{ 1, 2, 3, 4, 5 };
    try mergeSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "MergeSort werkt correct met een omgekeerde array" {
    var array: [5]i32 = [_]i32{ 5, 4, 3, 2, 1 };
    try mergeSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "MergeSort werkt correct met een array met herhaalde waarden" {
    var array: [7]i32 = [_]i32{ 4, 2, 4, 3, 1, 4, 2 };
    try mergeSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 2, 3, 4, 4, 4 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "MergeSort werkt correct met een array van één element" {
    var array: [1]i32 = [_]i32{42};
    try mergeSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{42};

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "MergeSort werkt correct met een willekeurige array" {
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };
    try mergeSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 11, 12, 22, 25, 64 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}
