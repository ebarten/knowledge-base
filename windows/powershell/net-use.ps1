param ($arg1,$arg2)

$out = net use $arg1 $arg2 2>&1
echo "out = $out"

# Replace any new lines with nothing to remain with a single line. Then store it into a oneLiner variable.
$oneLiner = $out -replace '[\r\n]',''
echo "one liner: $oneLiner"

# Capture digits only into errCode variable. Make sure that the previous variable is qouted 
# so that it remains as a single line.
if ("$oneLiner" -match '^(.*?)(?<errCode>\d+)(.*)$'){
	$errCode = [int]$($matches['errCode'])
} else {
	# In case there was no error - 'matches' will retrun False.
	$errCode = 0;
}
echo "errCode = '$errCode'"

function Error($errCode){
	exit $errCode;
}

function Success(){
	exit 0;
}

# Lets give wrong error code on purpose - in real life we could always change it back to 67
if ($errCode -eq 670) {
	Success;
} else {
	Error $errCode
}

# on powershell command line, after running the command: 
# PS> .\net-use.ps1 "W:" "\\216.58.194.164"
# run:
# PS> $?
# False
# PS> $LastExitCode
# 67

# You can see that the result is a failure (False) and the exit code is 67