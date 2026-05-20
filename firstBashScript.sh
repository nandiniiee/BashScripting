echo "Hello, this is us trying the bash script"
name="Riya
"
age="20"
gender="female"

echo "$name"
echo "$age"
echo "$gender"
unset age
age="23"
echo "$age"
echo "lets put elements into an array"
declare size
echo "what is the size of the array"
read size
echo "give $size  numbers to put into array (press enter and give a blank space to end your input)"
declare -a numbers
while true; do
	read number
	[[ -z "$number" ]] && break
	numbers+=("$number")
done
echo "Your number array"
for number in "${numbers[@]}";do
	echo $number
done
echo "Name of script: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "All arguments as string: $*"
echo "Count of arguments: $#"
echo "Current process ID: $$"
job=$1
state=$2
city=$3
echo "Job: $job"
echo "State: $state"
echo "City: $city"
unset age
echo "What is your age?"
read age
if [ "$age" -ge 18 ]; then
	echo "You can have a license"
elif [[ "$age" -ge 16 && "$age" -le 17 ]]; then
	echo "You can have learning license"
else
	echo "You cannot own a license"
fi
case "$name" in
	"Nandini") echo "case worked";;
	"Riya") echo "lol loser";;
	"Hiya") echo "bitch";;
esac
echo "creating or checking files"
echo "enter filename"
declare filename
read filename
if [ -e "$filename" ]

then
	echo "$filename exists in the directory"
	cat "$filename"
else
	cat > "$filename"
	echo "File created"
	# in this we are making a new file if the searched file doesnt exist
fi
myFirstFunction(){
	echo "Hieee, first function called"
}
myFirstFunction
secondFunction(){
	parameter_1=$1
	parameter_2=$2
	parameter_3=$3
	parameter_4=$4
	echo "first argument is $1"
	echo "second argument is $2"
	echo "third argument is $3"
	echo "fourth argument is $4"
}
secondFunction 1 2 3 4
ip=$(whiptail --inputbox "Enter IP Address" 10 50 3>&1 1>&2 2>&3)

