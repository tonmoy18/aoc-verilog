import sys

result = 0

prev_numbers = []
prev_start_positions = []
prev_end_positions = []
prev_gear_ratio = [-1]*141
with open (sys.argv[1]) as f:
  for line in f:
    print(line)
    gear_ratio = [-1]*141
    numbers = [0]*70
    current_num = 0
    num_start_positions = [-1]*70
    num_end_positions = [-1]*70
    current_num_idx = 0
    prev_c = ord('.')
    prev_scan_idx = 0
    prev_line_symbol_pos_in_range = -1
    flag_symbol_before_num = 0
    for i, c in enumerate(line):
      if (len(prev_numbers) > 0 and i > prev_end_positions[prev_scan_idx]  and prev_end_positions[prev_scan_idx] != -1 and prev_scan_idx < 69):
        prev_scan_idx += 1

      # char is a number
      if ord(c) >= ord('0') and ord(c) <= ord('9'):
        current_num = 10 * current_num + ( ord(c) - ord('0') )
        if (prev_c < ord('0') or prev_c > ord('9')):
          num_start_positions[current_num_idx] = i
          if prev_c == ord('*'):
            flag_symbol_before_num = 1
          if (i > 0 and prev_gear_ratio[i-1] >= 0):
            prev_line_symbol_pos_in_range = i-1
        if (prev_gear_ratio[i] >= 0):
          prev_line_symbol_pos_in_range = i
      else:
        # char is a gear char
        if ord(c) == ord('*'):
          gear_ratio[i] = 0
          if len(prev_numbers) > 0: # not first line
            # print("i: {}, scan_idx: {}, start_positions: {}".format(i, prev_scan_idx, prev_start_positions))
            if (i >= prev_start_positions[prev_scan_idx]-1 and i < prev_end_positions[prev_scan_idx]+1):
              print("INFO: adding A {} on current at {}".format(prev_numbers[prev_scan_idx], i))
              if gear_ratio[i] <= 0:
                gear_ratio[i] = prev_numbers[prev_scan_idx]
              else:
                result += gear_ratio[i] * prev_numbers[prev_scan_idx]
                print("INFO: result: {} on current at {}".format(result, i))
              prev_numbers[prev_scan_idx] = 0
              if (prev_scan_idx < 68 and prev_start_positions[prev_scan_idx+1] <= i+1):
                if (prev_numbers[prev_scan_idx+1] > 0):
                  print("INFO: adding D {} on current at {}".format(prev_numbers[prev_scan_idx+1], i))
                  if gear_ratio[i] <= 0:
                    gear_ratio[i] = prev_numbers[prev_scan_idx+1]
                  else:
                    result += gear_ratio[i] * prev_numbers[prev_scan_idx+1]
                    print("INFO: result: {} on current at {}".format(result, i))
                prev_numbers[prev_scan_idx+1] = 0
                prev_scan_idx += 1
        if ((ord(c) == ord('*'))):
          # before/after on same line
          if (current_num > 0):
            print("INFO: adding B {} on current at {}".format(current_num, i))
            print("INFO: current gear ratio: {}".format(gear_ratio[i]))
            if gear_ratio[i] <= 0:
              gear_ratio[i] = current_num
            else:
              result += gear_ratio[i] * current_num
              print("INFO: result: {} on current at {}".format(result, i))

            current_num = 0
        elif ((flag_symbol_before_num == 1)):
          # before/after on same line
          if (current_num > 0):
            print("INFO: adding B {} on current at {}".format(current_num, num_start_positions[current_num_idx]-1))
            print("INFO: current gear ratio: {}".format(num_start_positions[current_num_idx]-1))
            if gear_ratio[num_start_positions[current_num_idx]-1] <= 0:
              gear_ratio[num_start_positions[current_num_idx]-1] = current_num
            else:
              result += gear_ratio[num_start_positions[current_num_idx]-1] * current_num
              print("INFO: result: {} on current at {}".format(result, [num_start_positions[current_num_idx]-1]))

            current_num = 0
        else:
          if (current_num > 0):
            if (prev_line_symbol_pos_in_range >= 0 or prev_gear_ratio[i] >= 0):
              # result += current_num
              if prev_gear_ratio[prev_line_symbol_pos_in_range] >= 0:
                print("INFO: adding C {} at prev idx {}".format(current_num, prev_line_symbol_pos_in_range))
                if prev_gear_ratio[prev_line_symbol_pos_in_range] == 0:
                  prev_gear_ratio[prev_line_symbol_pos_in_range] = current_num
                else:
                  result += prev_gear_ratio[prev_line_symbol_pos_in_range] * current_num
              else:
                print("INFO: adding C {} at prev idx {}".format(current_num, i))
                if prev_gear_ratio[i] == 0:
                  prev_gear_ratio[i] = current_num
                else:
                  result += prev_gear_ratio[i] * current_num
              print("INFO: result: {} on prev".format(result))
              prev_line_symbol_pos_in_range = -1
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
    prev_gear_ratio           = list(gear_ratio)

    # print(numbers[0:current_num_idx], num_start_positions[0:current_num_idx], num_end_positions[0:current_num_idx])

print("RESULT: {}".format(result))



