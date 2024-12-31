const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const print = std.debug.print;

pub fn quickSort(array: []i32, low: usize, high: usize) void {
    if (low < high) {
        const pi = partition(array, low, high);

        if (pi > low) {
            quickSort(array, low, pi - 1);
        }
        quickSort(array, pi + 1, high);
    }
}

fn partition(array: []i32, low: usize, high: usize) usize {
    const pivot = array[high];
    var i: usize = low;

    for (low..high) |j| {
        if (array[j] < pivot) {
            swap(&array[i], &array[j]);
            i += 1;
        }
    }

    swap(&array[i], &array[high]);
    return i;
}

fn swap(a: *i32, b: *i32) void {
    const temp = a.*;

    a.* = b.*;
    b.* = temp;
}

test "quicksort werkt correct met een gesorteerde array" {
    var array: [5]i32 = [_]i32{ 1, 2, 3, 4, 5 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een omgekeerde array" {
    var array: [5]i32 = [_]i32{ 5, 4, 3, 2, 1 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 3, 4, 5 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een array met herhaalde waarden" {
    var array: [7]i32 = [_]i32{ 4, 2, 4, 3, 1, 4, 2 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 1, 2, 2, 3, 4, 4, 4 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een array van één element" {
    var array: [1]i32 = [_]i32{42};
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{42};

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}

test "quicksort werkt correct met een willekeurige array" {
    var array: [5]i32 = [_]i32{ 64, 25, 12, 22, 11 };
    quickSort(array[0..], 0, array.len - 1);
    const expected = [_]i32{ 11, 12, 22, 25, 64 };

    try testing.expectEqualSlices(i32, expected[0..], array[0..]);
}
