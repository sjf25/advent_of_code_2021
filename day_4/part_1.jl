function make_boards(str_input)
  boards = []
  working_board = []

  for line in rest
    if line == ""
      push!(boards, working_board)
      working_board = []
    else
      row::Vector{Union{Int64, Nothing}} = map(x->parse(Int64, x), split(strip(line), Regex("\\s+")))
      push!(working_board, row)
    end
  end
  push!(boards, working_board)

  boards
end

function board_wins(board)
  for i = 1:5
    row_count = 0
    col_count = 0
    for j = 1:5
      row_count += board[i][j] == nothing
      col_count += board[j][i] == nothing
    end
    if row_count == 5 || col_count == 5
      return true
    end
  end
  return false
end

function mark_board(board, num)
  for i in 1:5
    for j in 1:5
      if board[i][j] == num
        board[i][j] = nothing
      end
    end
  end
end

function board_sum(board)
  sum = 0
  for i in 1:5
    for j in 1:5
      if board[i][j] != nothing
        sum += board[i][j]
      end
    end
  end
  sum
end

function get_answer(boards)
  for m in marking_list
    for b in boards
      mark_board(b, m)
      if board_wins(b)
        b_sum = board_sum(b)
        #println(b_sum, ", ", m)
        return b_sum * m
      end
    end
  end
end

marking_list = map(x->parse(Int64, x), split(readline(), ","))
readline()
rest = readlines()

boards = make_boards(rest)

ans = get_answer(boards)
println(ans)
