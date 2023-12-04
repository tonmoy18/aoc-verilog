import sys

result = 0

prev_numbers = []
prev_start_positions = []
prev_end_positions = []
prev_special_symbol_flag = [0]*141
with open (sys.argv[1]) as f:
  for line in f:
    print(line)
    special_symbol_flag = [0]*141
    numbers = [0]*70
    current_num = 0
    prev_line_had_symbol_in_range = 0
    num_start_positions = [-1]*70
    num_end_positions = [-1]*70
    current_num_idx = 0
    prev_c = ord('.')
    flag_symbol_before_num = 0
    prev_scan_idx = 0
    for i, c in enumerate(line):
      if (len(prev_numbers) > 0 and i > prev_end_positions[prev_scan_idx]  and prev_end_positions[prev_scan_idx] != -1 and prev_scan_idx < 69):
        # print("INFO: i: {} prev_scan_idx: {}, prev_end_positions: {}".format(i, prev_scan_idx,prev_end_positions[prev_scan_idx]))
        prev_scan_idx += 1

      # Char is a number
      if ord(c) >= ord('0') and ord(c) <= ord('9'):
        current_num = 10 * current_num + ( ord(c) - ord('0') )
        if (prev_c < ord('0') or prev_c > ord('9')):
          num_start_positions[current_num_idx] = i
          if not(prev_c == ord('.') or prev_c == 10):
            flag_symbol_before_num = 1
          # print("INFO: {}".format(i))
          if (i > 0 and prev_special_symbol_flag[i-1] == 1):
            prev_line_had_symbol_in_range = 1
        if (prev_special_symbol_flag[i] == 1):
          prev_line_had_symbol_in_range = 1
      else:
        # Char is a special char
        if (ord(c) != ord('.') and ord(c) != 10):
          special_symbol_flag[i] = 1
          if (len(prev_numbers) > 0):
            # print("i: {}, scan_idx: {}, start_positions: {}".format(i, prev_scan_idx, prev_start_positions))
            if (i >= prev_start_positions[prev_scan_idx]-1 and i < prev_end_positions[prev_scan_idx]+1):
              result += prev_numbers[prev_scan_idx]
              print("INFO: adding A {}".format(prev_numbers[prev_scan_idx]))
              prev_numbers[prev_scan_idx] = 0
              if (prev_scan_idx < 68 and prev_start_positions[prev_scan_idx+1] <= i+1):
                result += prev_numbers[prev_scan_idx+1]
                print("INFO: adding D {}".format(prev_numbers[prev_scan_idx+1]))
                prev_numbers[prev_scan_idx+1] = 0
                prev_scan_idx += 1
        if ((flag_symbol_before_num == 1) or (ord(c) != ord('.') and ord(c) != 10)):
          # before/after on same time
          if (current_num > 0):
            result += current_num
            print("INFO: adding B {}".format(current_num))
            current_num = 0
        else:
          if (current_num > 0):
            print("INFO: i: {}".format(i))
            if (prev_line_had_symbol_in_range == 1 or prev_special_symbol_flag[i] == 1):
              result += current_num
              print("INFO: adding C {}".format(current_num))
              prev_line_had_symbol_in_range = 0
            else:
              numbers[current_num_idx] = current_num
              num_end_positions[current_num_idx]   = i
              current_num_idx += 1
            current_num = 0
        flag_symbol_before_num = 0
      prev_c = ord(c)


    prev_numbers              = list(numbers)
    prev_start_positions      = list(num_start_positions)
    prev_end_positions        = list(num_end_positions)
    prev_special_symbol_flag  = list(special_symbol_flag)

    # print(numbers[0:current_num_idx], num_start_positions[0:current_num_idx], num_end_positions[0:current_num_idx])

print("RESULT: {}".format(result))


