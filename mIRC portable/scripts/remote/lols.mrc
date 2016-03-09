;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:@lolcount*:#:{ if ($chan !isin %notlist) { msg $chan $col $+ I have seen %lol laughs since February 3rd 2008. } }
on *:TEXT:!lolcount*:#:{ if ($chan !isin %notlist) { notice $nick I have seen %lol laughs since February 3rd 2008. } }
on *:TEXT:*lol*:#:{ inc %lol }
on *:TEXT:*rofl*:#:{ inc %lol }
on *:TEXT:*lmao*:#:{ inc %lol }
on *:TEXT:*lmfao*:#:{ inc %lol }
on *:TEXT:*haha*:#:{ inc %lol }
on *:TEXT:*XD*:#:{ inc %lol }

on *:INPUT:*:{ if (lol isin $1-) { inc %lol } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
