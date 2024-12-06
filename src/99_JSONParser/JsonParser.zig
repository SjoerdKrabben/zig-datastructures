const std = @import("std");

const Dataset_sorteren = struct { lijst_aflopend_2: []i64, lijst_oplopend_2: []i64, lijst_float_8001: []f64, lijst_gesorteerd_aflopend_3: []i64, lijst_gesorteerd_oplopend_3: []i64, lijst_herhaald_1000: []i64, lijst_leeg_0: []i64, lijst_null_1: []i64, lijst_null_3: []i64, lijst_onsorteerbaar_3: []i64, lijst_oplopend_10000: []i64, lijst_willekeurig_10000: []i64, lijst_willekeurig_3: []i64 };

pub fn loadStrFromFile() !void {
    const allocator = std.heap.page_allocator;
    const file = try std.fs.cwd().openFile("assets/dataset_sorteren.json", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buffer: [1024]u8 = undefined;
    var count: usize = 0;


    var inside_quotes = false;
    var inside_brackets = false;
    const result = Dataset_sorteren{
        .lijst_aflopend_2 = &[_]i64{},
        .lijst_oplopend_2 = &[_]i64{},
        .lijst_float_8001 = &[_]f64{},
        .lijst_gesorteerd_aflopend_3 = &[_]i64{}, 
        .lijst_gesorteerd_oplopend_3 = &[_]i64{},
        .lijst_herhaald_1000 = &[_]i64{}, 
        .lijst_leeg_0 = &[_]i64{},
        .lijst_null_1 = &[_]i64{},
        .lijst_null_3 = &[_]i64{},
        .lijst_onsorteerbaar_3 = &[_]i64{},
        .lijst_oplopend_10000 = &[_]i64{},
        .lijst_willekeurig_10000 = &[_]i64{},
        .lijst_willekeurig_3 = &[_]i64{}
    };

    const label = std.ArrayList(u8).init(allocator);
    const data = std.ArrayList(u8).init(allocator);

    while (try in_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        std.debug.print("Count: {}, Item: {s}\n", .{ count, line });

        for (line) |c| {
            if(c == '"') {
                inside_quotes = !inside_quotes;
            }
            if(c == '[') {
                inside_brackets = true;
            }
            if(c == ']') {
                inside_brackets = false;
            }

            if(inside_quotes) {
                label.append(c);
            }

            if(inside_brackets) {
                data.append(c);
            }
            
            if(c == ',' and !inside_brackets){
                // map the label + data to the resultset
                const curLabel = label.toOwnedSlice();
                mapJsonToStruct(&result, curLabel, curData, allocator);
            }
            count = count + 1;
        }
        std.debug.print("Count: {}, Item: {s}\n", .{ count, buffer });

    }
}

pub fn mapJsonToStruct(result: *Dataset_sorteren, key: []u8, value: []u8, allocator: *std.mem.Allocator) void {

    if(std.mem.eql(u8, key, "lijst_aflopend_2")) {
        .result.lijst_aflopend_2 = allocator.alloc(i64, value.len);
        .result.lijst_aflopend_2.* = allocator.alloc(i64, value.len);
    } else if(std.mem.eql(u8, key, "lijst_oplopend_2")) {
        .result.lijst_oplopend_2 = allocator.alloc(i64, value.len);
        .result.lijst_oplopend_2.* = value;
    } else if(std.mem.eql(u8, key, "lijst_float_8001")) {
        .result.lijst_float_8001 = allocator.alloc(f64, value.len); 
        .result.lijst_float_8001.* = value;
    } else if(std.mem.eql(u8, key, "lijst_gesorteerd_aflopend_3")) {
        .result.lijst_gesorteerd_aflopend_3 = allocator.alloc(i64, value.len);
        .result.lijst_gesorteerd_aflopend_3.* = value;
    } else if(std.mem.eql(u8, key, "lijst_gesorteerd_oplopend_3")) {
        .result.lijst_gesorteerd_oplopend_3 = allocator.alloc(i64, value.len);
        .result.lijst_gesorteerd_oplopend_3.* = value;}
    else if(std.mem.eql(u8, key, "lijst_herhaald_1000")) {
        .result.lijst_herhaald_1000 = allocator.alloc(i64, value.len);
        .result.lijst_herhaald_1000.* = value;
    } else if(std.mem.eql(u8, key, "lijst_leeg_0")) {
        .result.lijst_leeg_0 = allocator.alloc(i64, value.len); 
        .result.lijst_leeg_0 = value;
    } else if(std.mem.eql(u8, key, "lijst_null_1")) {
        .result.lijst_null_1 = allocator.alloc(i64, value.len); 
        .result.lijst_null_1 = value;
    } else if(std.mem.eql(u8, key, "lijst_null_3")) {
        .result.lijst_null_3 = allocator.alloc(i64, value.len); 
        .result.lijst_null_3 = value;
    } else if(std.mem.eql(u8, key, "lijst_onsorteerbaar_3")) {
        .result.lijst_onsorteerbaar_3 = allocator.alloc(i64, value.len); 
        .result.lijst_onsorteerbaar_3 = value;
    } else if(std.mem.eql(u8, key, "lijst_oplopend_10000")) {
        .result.lijst_oplopend_10000 = allocator.alloc(i64, value.len); 
        .result.lijst_oplopend_10000 = value;
    } else if(std.mem.eql(u8, key, "lijst_willekeurig_10000")) {
        .result.lijst_willekeurig_10000 = allocator.alloc(i64, value.len); 
        .result.lijst_willekeurig_10000 = value;
    } else if(std.mem.eql(u8, key, "lijst_willekeurig_3")) {
        .result.lijst_willekeurig_3 = allocator.alloc(i64, value.len); 
        .result.lijst_willekeurig_3 = value;}

}
