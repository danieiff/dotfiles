if exists("b:current_syntax")
  finish
endif

syn match log_error '\c.*\<\(FATAL\|ERROR\|ERRORS\|E\d*: \|FAIL\|FAILED\|FAILURE\).*'
syn match log_warning '\c.*\<\(WARNING\|WARN\|DELETE\|DELETING\|DELETED\|RETRY\|RETRYING\).*'
syn match log_string '\c.*\<\(INFO\|DEBUG\).*'
syn region log_string start=/'/ end=/'/ end=/$/ skip=/\\./
syn region log_string start=/"/ end=/"/ skip=/\\./
syn match log_number '0x[0-9a-fA-F]*\|\[<[0-9a-f]\+>\]\|\<\d[0-9a-fA-F]*'

syn match log_date '\(Mon\|Tue\|Wed\|Thu\|Fri\|Sat\|Sun\) *'
syn match log_date '\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) [ 0-9]\d *'
syn match log_date '\d\{4}-\d\d-\d\d'

syn match log_time '\d\d:\d\d:\d\d\s*'
syn match log_time '\c\d\d:\d\d:\d\d\(\.\d\+\)\=\([+-]\d\d:\d\d\|Z\)'

hi def link log_string String
hi def link log_number Number
hi def link log_date Constant
hi def link log_time Type
hi def link log_error ErrorMsg
hi def link log_warning WarningMsg

let b:current_syntax = "log"
