# some ways to remove empty lines when splitting strings
# for example 

# $text = "Video  Video  Audio  Audio  VBI    VBI"
# $text.Split()
# outputs this

# Video

# Video

# Audio

# Audio

# VBI



# VBI

# 1. using powershell -split as unary operator
-split $text

# 2. Using powershell -split operator (use regular expression)
$text -split '\s+' #Here, the \s represents whitespace characters, and the + matches one or more of them.

# 3. Filter not null elements
$text.split()| where {$_}

# 3. using the .net split method :
$text.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)