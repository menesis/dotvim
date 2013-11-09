syntax clear
syntax match Comment  /[#-].*/
syntax match Constant /!.*/
syntax match Label    /^[0-9A-F]\{4\}:/
syntax match Define   /^[0-9A-F]\{4\}=[0-9A-F]\{4\}/

set foldmethod=expr foldexpr=getline(v:lnum)=~'^[0-9A-F]\\{4\\}[:=]'?'>1':getline(v:lnum)=~'^[-#!]'?1:0
